// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Hello_World {

    string saySomething;

    constructor() {
        saySomething = "Hello World!";
    }

    function speak() public view returns(string memory) {
        return saySomething;
    }
}