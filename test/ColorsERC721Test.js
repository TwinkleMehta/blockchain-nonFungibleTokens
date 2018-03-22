const contractDefinition = artifacts.require('./ColorsERC721.sol');
const BigNumber = web3.BigNumber;

contract('ColorsERC721', accounts => {
  let owner= accounts[0]
  let colors;

  beforeEach(async function() {
    colors = await contractDefinition.new({from: owner})
  })

  it('initial state', async function() {
    const name = await colors.name()
    const symbol = await colors.symbol()

    assert.equal(name, "COLORS")
    assert.equal(symbol, "HEX")
  })

  describe('mint', () => {
    let colorID = 1;
    let tx
    let price = new BigNumber(web3.toWei(.001, "ether"))

    beforeEach(async function (){
      tx = await colors.mint(colorID, {from: owner, value: price})
    })

    it ('minted a token that belongs to the owner', async function(){
      let tokenOwner = await colors.ownerOf(colorID)
      assert(tokenOwner, owner)
    })
  })

  describe('claim', () => {
    let secondOwner = accounts[1]
    let price = new BigNumber(web3.toWei(.001, "ether"))

    it ('owner mints the token and secondOwner claims it', async function(){
      let token = await colors.mint(1, {from: owner, value: price})

      let newPrice = new BigNumber(web3.toWei(.005, "ether"))

      await colors.claim(1,{from: secondOwner, value: newPrice})

      let realOwner = await colors.ownerOf(1)

      assert.equal(realOwner, secondOwner)

    })

  })
})
