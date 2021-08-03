//Write a smart contract to lock Uniswap V3 NFT and issue ERC20 equal to total liquidity in that NFT w.r.t token0.
//Eg. if token0 is DAI and token1 is ETH, and the NFT is holding 1 ETH and 1000 DAI, mint 2000 ERC20 tokens.

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
//import "..\..\faucet\faucet-contracts\contracts\TestToken.sol";
import "./Interfaces/IERC20.sol";


contract liquidityLock {
        using SafeMath for uint;
        bool public done;
        event LockedToken(uint totalStableCoin, address userAddress);
        mapping (address => uint) public tokenAddressToValue;
        mapping (address => uint) public tokensLocked;
        mapping (address => uint []) public tokenDetails;
        address public owner;
        address public lockedAt;
        constructor() {
               owner = msg.sender;
        }

        modifier onlyOwner(){
                require(msg.sender == owner ,'Not authorized');
                _;
        }

        function lockNFTandMint (uint token0,uint token1, address token0Address, address token1Address,  address myTokenAddress) external onlyOwner returns(address finder){
                uint product;
                uint takenValue;
                if (token0 > token1){
                       SafeMath.div(token0,token1)*100;
                         product.mul(2);
                         takenValue = convertValue(token0,token1);
                }else {
                         product = SafeMath.div(token1,token0)*100;
                         product.mul(2);
                         takenValue = convertValue(token1,token0);
                }

               finder =   transferToken (lockedAt,takenValue);

                tokensLocked[msg.sender] = tokensLocked[msg.sender].add(takenValue);
                tokenDetails[msg.sender].push(token0);
                tokenDetails[msg.sender].push(token1);
                emit LockedToken(product,msg.sender);
                minter(myTokenAddress,product);
                return lockedAt;

        }

        function convertValue(uint tkn1, uint tkn2) internal returns (uint){
                uint convertedValue ;
                convertedValue  = SafeMath.div(tkn1,tkn2);
                convertedValue.add(tkn1);
                return convertedValue;
        }

        function minter(address _tokenToBeMinted, uint _toBeMinted )internal returns (bool){
                IERC20(_tokenToBeMinted).mint(owner,_toBeMinted);
                done = true;
                return done;
        }

        function transferToken(address lockedAt, uint value) internal  returns (address){
                        IERC20(owner).transfer(lockedAt,value);
                        return lockedAt;
        }
}
