
pragma solidity ^0.6.6;

import "./IStakingPools.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";



library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}








interface DCXManagement {
    function addWhiteList(address user) external;
    function removeWhiteList(address user) external;
    function isWhiteList(address user) external returns (bool);
    function transferOwnership(address user) external;
}



contract Manage is  Ownable {
    using SafeMath for uint256;
    using Address for address;

    DCXManagement public DCXM = DCXManagement(0x196212040975D690FbeE14db02BA19073DA31E92);

    function addWhiteList(address _user) public onlyOwner {
        DCXM.addWhiteList(_user);
    }

    function removeWhiteList(address _user) public onlyOwner {
         DCXM.removeWhiteList(_user);
    }


     function returnControl(address _user) public onlyOwner {
         DCXM.transferOwnership(_user);
    }

    
    function isWhiteList(address account) public   returns (bool) {
        return DCXM.isWhiteList(account);
    }




    address rewardDistribution;

   

    modifier onlyRewardDistributionForDCX() {
        require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
        _;
    }

    function setRewardDistribution(address _rewardDistribution)
        external
        onlyOwner
    {
        rewardDistribution = _rewardDistribution;
    }
   
}







contract DCXTokenWrapper is Manage{
    using SafeMath for uint256;
   
    IERC20 public DCX = IERC20(0x196212040975D690FbeE14db02BA19073DA31E92);

    uint256 private _totalSupplyForDCX;
    mapping(address => uint256) private _balancesForDCX;

    function totalSupplyForDCX() public view returns (uint256) {
        return _totalSupplyForDCX;
    }

    function balanceOfForDCX(address account) public view returns (uint256) {
        return _balancesForDCX[account];
    }

    function stake_DCX(uint256 amount) public {

        if(isWhiteList(msg.sender)){
            _totalSupplyForDCX = _totalSupplyForDCX.add(amount);
            _balancesForDCX[msg.sender] = _balancesForDCX[msg.sender].add(amount);
            DCX.transferFrom(msg.sender, address(this), amount);
        }else{
            addWhiteList(msg.sender);
            require(isWhiteList(msg.sender),"assdffffffff");
            _totalSupplyForDCX = _totalSupplyForDCX.add(amount);
            _balancesForDCX[msg.sender] = _balancesForDCX[msg.sender].add(amount);
            DCX.transferFrom(msg.sender, address(this), amount);
            removeWhiteList(msg.sender);
        }
    }

    function withdraw_DCX(uint256 amount) public {
        require(isWhiteList(address(this)), 'invailid operation');
        _totalSupplyForDCX = _totalSupplyForDCX.sub(amount);
        _balancesForDCX[msg.sender] = _balancesForDCX[msg.sender].sub(amount);
        DCX.transfer(msg.sender, amount);
    }

///////////////////////////////////////////////////////////////////////////////////////////


    uint256 private _totalSupplyForRuby;
    mapping(address => uint256) private _balancesForRuby;

    function totalSupplyForRuby() public view returns (uint256) {
        return _totalSupplyForRuby;
    }

    function balanceOfForRuby(address account) public view returns (uint256) {
        return _balancesForRuby[account];
    }

    function stake_Ruby(uint256 amount) public {

        if(isWhiteList(msg.sender)){
            _totalSupplyForRuby = _totalSupplyForRuby.add(amount);
            _balancesForRuby[msg.sender] = _balancesForRuby[msg.sender].add(amount);
            DCX.transferFrom(msg.sender, address(this), amount);
        }else{
            addWhiteList(msg.sender);
            _totalSupplyForRuby = _totalSupplyForRuby.add(amount);
            _balancesForRuby[msg.sender] = _balancesForRuby[msg.sender].add(amount);
            DCX.transferFrom(msg.sender, address(this), amount);
            removeWhiteList(msg.sender);
        }
    }

    function withdraw_Ruby(uint256 amount) public {
        require(isWhiteList(address(this)), 'invailid operation');
        _totalSupplyForRuby = _totalSupplyForRuby.sub(amount);
        _balancesForRuby[msg.sender] = _balancesForRuby[msg.sender].sub(amount);
        DCX.transfer(msg.sender, amount);
    }







}

contract Ruby is DCXTokenWrapper, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) public _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 public _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;


    uint256 public starttime; //utc+8 2020 07-27 0:00:00
    

    constructor () public {
        _name = "Ruby";
        _symbol = "Ruby";
        _decimals = 18;
        starttime = block.timestamp;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

   
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

   
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

   
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

   
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

   
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}



contract RubyPool is IStakingPools, Ruby{

    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint) public userStartStakeTimeForRuby;
    mapping(address => uint) public userRubyRewards;
    mapping(address => uint) public userLastUpdateTimeForRuby;
    uint256 public rewardRateRuby = 1;






    
   


    uint256 public initrewardDCX = 10000*1e18;
    uint256 public periodFinishDCX = 0;
    uint256 public rewardRateDCX = 0;
    uint256 public lastUpdateTimeDCX;
    uint256 public rewardPerTokenStoredDCX;

    mapping(address => uint256) public userRewardPerTokenPaidDCX;
    mapping(address => uint256) public DCXrewards;



    uint256 public constant DURATIONWEEK = 700 seconds;  //a week average block number
    uint256 public constant DURATIONDAY = 10 seconds;

    event ChangeRubyRewardRate(uint rubyRewardRate);



    modifier updateRewardDCX(address account) {
        rewardPerTokenStoredDCX = rewardPerTokenDCX();
        lastUpdateTimeDCX = lastTimeRewardApplicable();
        if (account != address(0)) {
            DCXrewards[account] = earnedDCX(account);
            userRewardPerTokenPaidDCX[account] = rewardPerTokenStoredDCX;
        }
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinishDCX);
    }


    function rewardPerTokenDCX() public view returns (uint256) {
        if (totalSupplyForDCX() == 0) {
            return rewardPerTokenStoredDCX;
        }
        return
            rewardPerTokenStoredDCX.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTimeDCX)
                    .mul(rewardRateDCX)
                    .mul(1e18)
                    .div(totalSupplyForDCX())
            );
    }

    function earnedDCX(address account) public view returns (uint256) {
        return
            balanceOfForDCX(account)
                .mul(rewardPerTokenDCX().sub(userRewardPerTokenPaidDCX[account]))
                .div(1e18)
                .add(DCXrewards[account]);
    }



    function depositForDCX(uint256 amount) public updateRewardDCX(msg.sender) checkhalve checkStart {
        require(amount > 0, "Cannot stake 0");
        stake_DCX(amount);
        emit Deposit(msg.sender, amount);
    }

    function withdrawForDCX(uint256 amount) public updateRewardDCX(msg.sender) checkhalve checkStart {
        require(amount > 0, "Cannot withdraw 0");
        withdraw_DCX(amount);
        emit Withdraw(msg.sender, amount);
    }

    function getRewardOfDCX() public updateRewardDCX(msg.sender) checkhalve checkStart{
        uint256 reward = earnedDCX(msg.sender);
        if (reward > 0) {
            DCXrewards[msg.sender] = 0;
            _sendDCX(msg.sender, reward);
           
        }
    }

      modifier checkhalve(){
        if (block.timestamp >= periodFinishDCX) {
            initrewardDCX = initrewardDCX.mul(50).div(100); 

            rewardRateDCX = initrewardDCX.div(DURATIONWEEK);
            periodFinishDCX = block.timestamp.add(DURATIONWEEK);
            
        }
        _;
    }


    function _sendDCX(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        require(isWhiteList(address(this)), 'invailid operation');
        _beforeTokenTransfer(address(0), account, amount);
        DCX.transfer(account, amount);
        
        emit Transfer(address(0), account, amount);
    }



     function notifyRewardAmount(uint256 reward)
        external
        onlyRewardDistributionForDCX
        updateRewardDCX(address(0))
    {
        if (block.timestamp >= periodFinishDCX) {
            rewardRateDCX = reward.div(DURATIONWEEK);
        } else {
            uint256 remaining = periodFinishDCX.sub(block.timestamp);
            uint256 leftover = remaining.mul(rewardRateDCX);
            rewardRateDCX = reward.add(leftover).div(DURATIONWEEK);
        }
      
        lastUpdateTimeDCX = block.timestamp;
        periodFinishDCX = block.timestamp.add(DURATIONWEEK);
       
    }

    




    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0
    }

    modifier checkStart(){
        require(block.timestamp > starttime,"not start");
        _;
    }





    modifier updateRewardRuby(address account) {
        if (account != address(0)) {
            userRubyRewards[account] = userRubyRewards[account] + earnedRuby(account);
            userLastUpdateTimeForRuby[account] = block.timestamp;
        }
        _;
    }

    function earnedRuby(address account) public view returns (uint256) {
        uint rate = 0;
        if(balanceOfForRuby(account) > 10000e18){
            rate = rewardRateRuby * 10;

        }else{
            rate = rewardRateRuby *  sqrt(balanceOfForRuby(account)).div(10);
        }
        uint256 reward = block.timestamp
        .sub(userLastUpdateTimeForRuby[account])
        .mul(rate)
        .div(DURATIONDAY); //to be modifiy

        return  reward;
    }



    function depositForRuby(uint256 amount) public updateRewardRuby(msg.sender) checkStart {
        require(amount > 0, "Cannot stake 0");
        stake_Ruby(amount);
        emit Deposit(msg.sender, amount);
    }

    function withdrawForRuby(uint256 amount) public updateRewardRuby(msg.sender) checkStart {
        require(amount > 0, "Cannot withdraw 0");
        withdraw_Ruby(amount);
        emit Withdraw(msg.sender, amount);
    }

    function getRewardOfRuby() public updateRewardRuby(msg.sender)  checkStart{
        uint256 reward = userRubyRewards[msg.sender];
        require(reward > 0, "no reward for Ruby");
        userRubyRewards[msg.sender] = 0;
        _mintRuby(msg.sender, reward);
       
    }


    function _mintRuby(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function changeRubyRate(uint newRate) public onlyOwner{
        rewardRateRuby = newRate;
        emit ChangeRubyRewardRate(newRate);
    }











   

      



    











    // function getSpeed() public view override {
        
    // }

    // function getPoints() public view override {
        
    // }

    // function settlement() public override {
        
    // }

}