pragma solidity >=0.8.0;


library  tokenPosition{
    struct tokenInfo{
        uint tokenId;
        uint cliff;
        uint startTimestamp;
        uint diuration;
        bool allowFeeClaim;
        address owner;
        address feeReceiver;
    }

    function isPositionValid(tokenInfo memory info) internal view{
        require(info.owner != address (0),'Zero address error');
        require(info.owner == msg.sender,"Not the owner");
        require(info.diuration >= info.cliff ,"Please Wait");
        require(info.startTimestamp + info.diuration >= block.timestamp,"Zero address error");
    }

    function isOwner(tokenInfo memory info) internal view{
        require(info.owner==msg.sender,"You are not the owner");
    }

    function isTokenValid(tokenInfo memory info,uint tokenId) internal view{
        require(info.tokenId == tokenId,'The token is not valid');
    }

    function isFeeClaimAllowed(tokenInfo memory info) internal view{
        require(info.startTimestamp+info.cliff <= block.timestamp,'Please wait');
        require(info.allowFeeClaim,'Not allowed');
    }
    function isTokenActionAllowed(tokenInfo memory info) internal view{
        require(info.diuration+info.startTimestamp == block.timestamp,'Actions upon the token is allowed');
    }
}