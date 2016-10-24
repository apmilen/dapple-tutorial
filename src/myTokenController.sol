pragma solidity ^0.4.2;

import "ds-token/controller.sol";

contract MyTokenControllerEvents {
    event AccountTransferPermissionSet(address account, bool value);
}

contract MyTokenController is DSTokenController, MyTokenControllerEvents {

    mapping( address => bool ) canTransfer;

    function MyTokenController( 
        DSTokenFrontend frontend, 
        DSBalanceDB baldb, 
        DSApprovalDB apprdb ) DSTokenController( 
            frontend, 
            baldb, 
            apprdb ) {}

    function transfer(address _caller, address to, uint value)
             auth()
             returns (bool ok)
    {
        if ( canTransfer[_caller] != true ) throw;

        return DSTokenController.transfer(_caller, to, value);
    }

    function setAccountTransferPermission(address account, bool value) 
             auth()
    {
        canTransfer[account] = value;
        AccountTransferPermissionSet(account, value);
    }

    function getAccountTransferPermission(address account) 
             returns (bool permission) {
        return canTransfer[account];
    }
}
