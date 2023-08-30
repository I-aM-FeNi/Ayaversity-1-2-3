require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const Private_Key = "410d3f56913852a5bb467ff72167b544b29eada5ab5cf5dd35ea7ea6cc1f9aca"

module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
        url: "https://crimson-boldest-sea.ethereum-sepolia.discover.quiknode.pro/731edb861e8689f0dc3da38746045f7dbfa58af0/",
        accounts: [`0x${Private_Key}`]
    }
  }
};