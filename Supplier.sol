// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;


contract Supplier {
  
  // Declare an event for addeding the item. 
  event ItemAdded(uint idItem);
  
  // Declare an event for processing the order. 
  event ProcessAnOrder(uint idOfCustomer, uint idOrder, bool status);

  // Define a struct to store information about items and orders
  struct Item {
    uint idItem;
    string itemName;
    uint price;
  }

  struct Orderlog {
    uint idOfCustomer;
    uint idOrder; 
    bool status;
  }

  // Store the total number of items for sale, order for process, 
  uint numItemsForSale; 
  uint numOrdersProcessed;
  
  // Mapping item to item information and order to order information
  mapping (uint => Item) items;
  mapping (uint => Orderlog) orderLogs;

  // Function addItem for adding an item for sale
  function addItem(string memory _itemName, uint _price) public {
    uint idItem = numItemsForSale++;
    items[idItem] = Item(idItem, _itemName, _price);
    emit ItemAdded(idItem);
  }

  // Function processOrder for Processing an order
  function processOrder(uint _idOrder, uint _idCustomer) public {
    orderLogs[_idOrder] = Orderlog(_idCustomer, _idOrder, true);
    numOrdersProcessed++;
    emit ProcessAnOrder(_idCustomer, _idOrder, true);
  }

  // Function getItem retrieve information about an item
  // and return the item name and price
  function getItem(uint _idItem) view public returns (string memory, uint){
  return (items[_idItem].itemName, items[_idItem].price);
  }

  // Function getTotalNumberOfItemsForSale retrieve 
  // total number of items for sale and Return them.
  function getTotalNumberOfItemsForSale() view public returns (uint) {
  return numItemsForSale;
  }

  // Function getTotalNumberOfOrdersProcessed Retrieve
  // the total number of orders processed and return them. 
  function getTotalNumberOfOrdersProcessed() view public returns (uint){
  return numOrdersProcessed;
  }

}
