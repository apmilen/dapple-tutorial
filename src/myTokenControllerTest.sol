pragma solidity ^0.4.2;

import "dapple/test.sol";
import "ds-token/factory.sol";
import "./myTokenController.sol";

contract MyTokenControllerTest is Test, MyTokenControllerEvents {


    MyTokenController controller;
    DSTokenFactory factory;

    function setUp() {
        factory = new DSTokenFactory();
        
        controller = new MyTokenController(
            factory.buildDSTokenFrontend(),
            factory.buildDSBalanceDB(),
            factory.buildDSApprovalDB()
        );
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
