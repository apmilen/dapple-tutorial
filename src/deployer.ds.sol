pragma solidity ^0.4.2;

import "dapple/script.sol";

import 'ds-token/data/balance_db.sol';
import 'ds-token/data/approval_db.sol';
import 'ds-token/frontend.sol';

import "./myTokenController.sol";

contract DeploymentScript is Script {

    function DeploymentScript() {

        var authority = new DSBasicAuthority();


        var approval_db = new DSApprovalDB();
        var balance_db = new DSBalanceDB();
        var frontend = new DSTokenFrontend();
        
        var controller = new MyTokenController(frontend, balance_db, approval_db);

        frontend.setController( controller );
        
        balance_db.setAuthority(authority);
        approval_db.setAuthority(authority);
        controller.setAuthority(authority);
        frontend.setAuthority(authority);

        // The only data ops the controller does is `move` balances and `set` approvals.
        authority.setCanCall( controller, balance_db,
                             bytes4(sha3("moveBalance(address,address,uint256)")), true );
        authority.setCanCall( controller, approval_db,
                             bytes4(sha3("setApproval(address,address,uint256)")), true );

        // The controller calls back to the frontend for the 2 events.
        authority.setCanCall( controller, frontend,
                             bytes4(sha3("emitTransfer(address,address,uint256)")), true );
        authority.setCanCall( controller, frontend,
                             bytes4(sha3("emitApproval(address,address,uint256)")), true );

        // The frontend can call the proxy functions.
        authority.setCanCall( frontend, controller,
                             bytes4(sha3("transfer(address,address,uint256)")), true );
        authority.setCanCall( frontend, controller,
                             bytes4(sha3("transferFrom(address,address,address,uint256)")),
                             true );

        authority.setCanCall( frontend, controller,
                             bytes4(sha3("approve(address,address,uint256)")), true );

        
    }
}
