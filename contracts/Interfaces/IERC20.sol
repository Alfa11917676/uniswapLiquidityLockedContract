pragma solidity ^0.8.0;

interface IERC20{
   // event mint (address toTheMinter, uint mintedTokens );
    event Transfer (address toTheMinter, uint mintedTokens, bool supplied);
   // function name () external  view returns (string memory);
  //  function totalSupply () external view returns (uint);
    function mint(address accountAddress,  uint amount) external ;
    function balanceOf(address accountAddress) external view returns(uint);
    function transfer(address _to, uint _amount) external returns(bool);
//    function transferFrom(address from, address to, uint value) external returns (bool);
}