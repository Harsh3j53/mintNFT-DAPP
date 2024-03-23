const { ethers } = require("hardhat");

async function main() {
    const RoboPunksNFT = await ethers.getContractFactory("RoboPunksNFT");
    const roboPunksNFT = await RoboPunksNFT.deploy();

    console.log("Deploying Contract...");
    console.log("Contract deployed to address:", await roboPunksNFT.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


