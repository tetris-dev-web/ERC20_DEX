const DEX = artifacts.require("DEX")

module.exports = async function (deployer, networks, acoounts) {
    // deploy DEX
    deployer.deploy(DEX)
}