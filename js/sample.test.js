import sample from '../js/sample'
import sinon from 'sinon'
import assert from 'assert'

describe('sample', () => {
  it('should work with sinon', () => {
    const spy = sinon.spy()
    spy(5)
    assert.ok(spy.calledOnce)
    assert.ok(spy.calledWith(5))
  })

  describe('sum', () => {
    it('should add 2 numbers', () => {
      assert.strictEqual(sample.sum(3, 5), 8)
    })
  })

  describe('product', () => {
    it('should multiply 2 numbers', () => {
      assert.strictEqual(sample.product(3, 5), 15)
    })
  })
})
