// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../system/SystemContract.sol";
import "../interfaces/zContract.sol";
import "../shared/SwapHelperLib.sol";

contract ZetaSwapV2 is zContract {
    SystemContract public immutable systemContract;

    constructor(address systemContractAddress) {
        systemContract = SystemContract(systemContractAddress);
    }

    function onCrossChainCall(address zrc20, uint256 amount, bytes calldata message) external virtual override {
        (address targetZRC20, bytes32 receipient, uint256 minAmountOut) = abi.decode(
            message,
            (address, bytes32, uint256)
        );
        uint256 outputAmount = SwapHelperLib._doSwap(
            systemContract.wZetaContractAddress(),
            systemContract.uniswapv2FactoryAddress(),
            systemContract.uniswapv2Router02Address(),
            zrc20,
            amount,
            targetZRC20,
            minAmountOut
        );
        SwapHelperLib._doWithdrawal(targetZRC20, outputAmount, receipient);
    }
}
