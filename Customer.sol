// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract CustomerDB {

// The event OrderPurchased is triggered when a new order is purchased.
event OrderPurchased(uint idOrder);

// The event OrderShipped is triggered when an order is shipped.
event OrderShipped(uint idOrder);

// The struct Customer is used to store information about customers like customer identifier and name of the customer
struct Customer {
uint idCustomer; 
string customerName; 
}

// The struct Order is used to store information about orders like order identifier
// customer id, item name, and order quantity and indicate the order has been shiped or no.
struct Order {
uint idOrder; 
uint idCustomer; 
string itemName; 
uint quantity; 
bool shipped; 
}

// idOrder is keep track for next order id. 
uint idOrder = 0;

// Mapping for storing customers information. 
mapping (uint => Customer) customers;

// Mapping for storing orders information. 
mapping (uint => Order) orders;

// The constructor is called when the contract is deployed.
// Currently adding customers in the constructor but commented out to show understanding.
/*
constructor() public {
customers[0] = Customer(0, "John Smith");
customers[1] = Customer(1, "Sarah Webster");
customers[2] = Customer(2, "Dev Patel");
}
*/


// The function addCustomer is for adding new customers 
function addCustomer(uint _idCustomer, string _customerName) public {
customers[_idCustomer] = Customer(_idCustomer, _customerName);
}


// The function purchaseItem is for purchase a new item, then will go for next order id
// and create new order then trigger the orderPurchased
function purchaseItem(uint _custId, string _itemName, uint _quantity) public {
idOrder++; 
orders[idOrder] = Order(idOrder, _custId, _itemName, _quantity, false); 
emit OrderPurchased(idOrder); 
}

// The function shipItem is for ship an order and mention the order shiped then trigger event
function shipItem(uint _idOrder) public {
orders[_idOrder].shipped = true; 
emit OrderShipped(_idOrder); 
}

// The function getOrderDetails is for retrieving order details.
// and return the customer ID, customer name, item name, quantity, and shipping status
function getOrderDetails(uint _idOrder) view public returns (uint, string, string, uint, bool){
uint cust = orders[_idOrder].idCustomer; 
return (cust, customers[cust].customerName, orders[_idOrder].itemName, orders[_idOrder].quantity, orders[_idOrder].shipped); 
}
}



