pragma solidity ^0.4.2;

import "dapple/test.sol";
import "ds-token/frontend.sol";
import "ds-token/data/approval_db.sol";
import "ds-token/data/balance_db.sol";
import "ds-auth/basic_authority.sol";

import "./myTokenController.sol";

contract MyTokenControllerTest is Test, MyTokenControllerEvents {


    MyTokenController controller;

    DSTokenFrontend frontend;
    DSApprovalDB approval_db;
    DSBalanceDB balance_db;

    DSBasicAuthority authority;


    function setUp() {

        authority =  new DSBasicAuthority();

        approval_db = new DSApprovalDB();
        balance_db = new DSBalanceDB();
        frontend = new DSTokenFrontend();
        
        controller = new MyTokenController(
            frontend,
            balance_db,
            approval_db
        );

        balance_db.setAuthority(authority);
        approval_db.setAuthority(authority);
        controller.setAuthority(authority);
        frontend.setAuthority(authority);

        authority.setCanCall( controller, balance_db, bytes4(sha3(
            "moveBalance(address,address,uint256)")), true );
        authority.setCanCall( controller, frontend, bytes4(sha3(
            "emitTransfer(address,address,uint256)")), true );
    }

    function testSetAccountTransferPermission() {
        expectEventsExact(controller);
        AccountTransferPermissionSet(address(this), true);
        controller.setAccountTransferPermission(address(this), true);
    }
    
    function testTransfer() {
        controller.getBalanceDB().addBalance(this, 1000);
        controller.setAccountTransferPermission(address(this), true);
        assertTrue(controller.transfer(address(this), address(0x123), 1));
    }

    function testFailTransfer() {
        controller.getBalanceDB().addBalance(this, 1000);
        controller.transfer(address(this), address(0x123), 1);
    }
}
