pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EtherC2C {
    uint256 id;

    struct Order {
        address owner;
        uint256 amount;
        //1 sellETH 2 sellToken 3 buyETH 4 buyToken
        uint256 oType;
        string info;
        address token;
        //1 active 2 deposited 3 inactive
        uint256 status;
    }

    mapping(uint256 => Order) public orders;

    event CreateOrder(
        uint256 id,
        address indexed owner,
        uint256 amount,
        uint256 indexed oType,
        string info,
        address indexed token
    );

    function createOrder(
        uint256 _amount,
        string memory _info,
        uint256 _oType,
        address _token
    ) external {
        require(_oType == 1 || _oType == 2 || _oType == 3 || _oType == 4);
        orders[id] = Order({
            owner: msg.sender,
            amount: _amount,
            oType: _oType,
            info: _info,
            token: _token,
            status: 1
        });

        emit CreateOrder(id, msg.sender, _amount, _oType, _info, _token);
        id++;
    }

    function closeOrder(uint256 _id) external {
        require(orders[_id].owner == msg.sender);
        require(orders[_id].status == 1);
        orders[_id].status = 3;
    }

    function depositETH(uint256 _id) external payable {
        require(orders[_id].amount == msg.value);
        require(orders[_id].oType == 1 || orders[_id].oType == 3);
        require(orders[_id].status == 1);
        orders[_id].status = 2;
    }

    function depositToken(uint256 _id, uint256 _amount) external {
        require(orders[_id].amount == _amount);
        require(orders[_id].oType == 2 || orders[_id].oType == 4);
        require(orders[_id].status == 1);
        IERC20(orders[_id].token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        orders[_id].status = 2;
    }
}
