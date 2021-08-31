//Write a smart contract to lock Uniswap V3 NFT and issue ERC20 equal to total liquidity in that NFT w.r.t token0.
//Eg. if token0 is DAI and token1 is ETH, and the NFT is holding 1 ETH and 1000 DAI, mint 2000 ERC20 tokens.

pragma solidity >=0.8.5;
pragma  abicoder v2;
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Interfaces/INonfungiblePositionMamager.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./library/tokenPosition.sol";


contract pool {
    using tokenPosition for tokenPosition.tokenInfo;
    mapping (uint => tokenPosition.tokenInfo) public lpt;
    uint128 private constant MAX_UINT128 = type(uint128).max;
    INonfungiblePositionManager private _uniswapNFTPosition;
    constructor (){
        _uniswapNFTPosition= INonfungiblePositionManager(0xDAa2031432cD9e07316A66d5c95B5A4434Ffc781);
    }
    function lockNft(tokenPosition.tokenInfo calldata params) external returns (bool){
        _uniswapNFTPosition.transferFrom(msg.sender,address (this),params.tokenId);
        params.isPositionValid();
        params.isTokenValid(params.tokenId);
        lpt[params.tokenId] = params;
        return true;
    }
    function claimNFTFee(uint tokenId)external returns (uint amount1,uint amount2){
        tokenPosition.tokenInfo memory params = lpt[tokenId];
        params.isTokenValid(tokenId);
        params.isFeeClaimAllowed();
        (amount1,amount2) = _uniswapNFTPosition.collect(
        INonfungiblePositionManager.CollectParams(tokenId,params.feeReceiver,MAX_UINT128,MAX_UINT128)
        );
        mintToken(amount1,amount2,tokenId);
    }
    function mintToken(uint amount1, uint amount2, uint tokenID) internal{
        tokenPosition.tokenInfo memory params = lpt[tokenID];
        uint amountOfTokenToMint;
        uint temp;
        if (amount1> amount2){
                amountOfTokenToMint = amount2 / amount1;
                temp = amount2 % amount1;
                amountOfTokenToMint *= temp;
        }else{
            amountOfTokenToMint = amount1 / amount2;
            temp = amount1 % amount2;
            amountOfTokenToMint *= temp;
        }
        ERC20(params.owner,amountOfTokenToMint);
    }
}
