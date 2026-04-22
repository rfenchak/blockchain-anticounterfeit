// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ProductRegistry {

    struct CustodyEvent {
        address actor;
        string  stage;
        string  location;
        uint256 timestamp;
    }

    struct ConditionEvent {
        address actor;
        string  condition;
        bool    onHold;
        string  notes;
        uint256 timestamp;
    }

    struct Product {
        string  productId;
        string  name;
        string  metadata;
        address manufacturer;
        bool    exists;
        string  currentCondition;
        bool    onHold;
    }

    mapping(string => Product) private products;
    mapping(string => CustodyEvent[]) private custodyHistory;
    mapping(string => ConditionEvent[]) private conditionHistory;

    event ProductRegistered(
        string  productId,
        string  name,
        address manufacturer,
        uint256 timestamp
    );

    event CustodyTransferred(
        string  productId,
        address actor,
        string  stage,
        string  location,
        uint256 timestamp
    );

    event ConditionUpdated(
        string  productId,
        address actor,
        string  condition,
        bool    onHold,
        string  notes,
        uint256 timestamp
    );

    function registerProduct(
        string memory productId,
        string memory name,
        string memory metadata
    ) public {
        require(!products[productId].exists, "Product already registered");

        products[productId] = Product({
            productId:        productId,
            name:             name,
            metadata:         metadata,
            manufacturer:     msg.sender,
            exists:           true,
            currentCondition: "Good",
            onHold:           false
        });

        custodyHistory[productId].push(CustodyEvent({
            actor:     msg.sender,
            stage:     "Manufactured",
            location:  metadata,
            timestamp: block.timestamp
        }));

        emit ProductRegistered(productId, name, msg.sender, block.timestamp);
    }

    function transferCustody(
        string memory productId,
        string memory stage,
        string memory location
    ) public {
        require(products[productId].exists, "Product not found");
        require(!products[productId].onHold, "Product is on hold due to condition issue - resolve before transferring");

        custodyHistory[productId].push(CustodyEvent({
            actor:     msg.sender,
            stage:     stage,
            location:  location,
            timestamp: block.timestamp
        }));

        emit CustodyTransferred(productId, msg.sender, stage, location, block.timestamp);
    }

    function updateCondition(
        string memory productId,
        string memory condition,
        bool          onHold,
        string memory notes
    ) public {
        require(products[productId].exists, "Product not found");

        products[productId].currentCondition = condition;
        products[productId].onHold           = onHold;

        conditionHistory[productId].push(ConditionEvent({
            actor:     msg.sender,
            condition: condition,
            onHold:    onHold,
            notes:     notes,
            timestamp: block.timestamp
        }));

        emit ConditionUpdated(productId, msg.sender, condition, onHold, notes, block.timestamp);
    }

    function getProduct(string memory productId)
        public view
        returns (string memory, string memory, string memory, address, string memory, bool)
    {
        require(products[productId].exists, "Product not found");
        Product memory p = products[productId];
        return (p.productId, p.name, p.metadata, p.manufacturer, p.currentCondition, p.onHold);
    }

    function getHistory(string memory productId)
        public view
        returns (CustodyEvent[] memory)
    {
        require(products[productId].exists, "Product not found");
        return custodyHistory[productId];
    }

    function getConditionHistory(string memory productId)
        public view
        returns (ConditionEvent[] memory)
    {
        require(products[productId].exists, "Product not found");
        return conditionHistory[productId];
    }

    function isAuthentic(string memory productId)
        public view
        returns (bool)
    {
        return products[productId].exists;
    }
}