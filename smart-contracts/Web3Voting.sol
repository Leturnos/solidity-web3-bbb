// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Voting {
    string option1;
    uint256 votes1;
    string option2;
    uint256 votes2;
    uint256 maxDate;
}

struct Vote {
    uint256 choice; //1 or 2
    uint256 date;
}

contract Web3Voting {
    address public owner;
    uint256 public currentVoting = 0;
    Voting[] public votings;
    mapping(uint256 => mapping(address => Vote)) public votes;

    constructor() {
        owner = msg.sender; // By default, the deployer becomes the owner
    }

    function getCurrentVoting() public view returns (Voting memory) { // view functions do not cost gas when called externally
        return votings[currentVoting];
    }

    function addVoting(
        string memory option1, // memory = temporary data location, not stored on-chain
        string memory option2,
        uint256 timeToVote
    ) public {
        require(msg.sender == owner, "Invalid sender"); // access control

        if (votings.length != 0) currentVoting++;

        Voting memory newVoting;
        newVoting.option1 = option1;
        newVoting.option2 = option2;
        newVoting.maxDate = timeToVote + block.timestamp; // block.timestamp returns the current block time
        votings.push(newVoting);
    }

    function addVote(uint256 choice) public {
        require(choice == 1 || choice == 2, "Invalid choice");
        require(votings[currentVoting].maxDate > block.timestamp, "No open voting");
        require(
            votes[currentVoting][msg.sender].date == 0,
            "You already voted on this voting"
        );

        votes[currentVoting][msg.sender].choice = choice;
        votes[currentVoting][msg.sender].date = block.timestamp;

        if (choice == 1) votings[currentVoting].votes1++;
        else votings[currentVoting].votes2++;
    }
}