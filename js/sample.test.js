import sample from '../js/sample'

describe('sample', () => {
  it('should pass the framework setup tests', () => { // `mocha` globals are recognized by eslint
    'apples'.should.not.equal('oranges') // `should` assertion style works
    expect(2 + 2).to.equal(4) // the global "expect" is recognized by eslint
    expect(true && false).to.be.false() // calling `false` enabled by `dirty-chai`
    const spy = sinon.spy() // the global "sinon" is recognized by eslint
    spy(5)
    spy.should.be.calledOnce.calledWith(5) // `called*`, etc enabled by `chai-sinon`
  })

  describe('sum', () => {
    it('should add 2 numbers', () => {
      sample.sum(3, 5).should.equal(8)
    })
  })

  describe('product', () => {
    it('should multiply 2 numbers', () => {
      sample.product(3, 5).should.equal(15)
    })
  })
})
