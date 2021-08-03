const { ChainId, Fetcher , WETH,  Route} = require('@uniswap/sdk');
const {ethers} = require('hardhat');
const chainID = ChainId.MAINNET;
const tokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F';
const priceFetcher = async () => {
    const dai  =await  Fetcher.fetchTokenData(chainID,tokenAddress);
    const weth = WETH[chainID];
    const pair = await  Fetcher.fetchPairData(dai,weth);
    const route = new Route([pair],weth);
    console.log(route.midPrice.toSignificant(6))
    return (route.midPrice.toSignificant(6));
}

console.log(priceFetcher());
