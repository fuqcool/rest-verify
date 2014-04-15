HttpRequest = require '../lib/http'

describe 'http', ->
  request = null
  mockRequest = null
  mockClient = null

  beforeEach ->
    request = new HttpRequest
    mockRequest =
      on: jasmine.createSpy('request.on')
      end: jasmine.createSpy('request.end')

    mockClient = {request: jasmine.createSpy('client').andReturn(mockRequest)}
    spyOn(request, '_getClient').andReturn mockClient

  it 'should have default values', ->
    expect(request.protocol).toBe 'http'
    expect(request.headers).toEqual {}
    expect(request.path).toBe '/'
    expect(request._getDefaultPort()).toBe 80

  it 'should have default port for https', ->
    request.protocol = 'https'
    request.execute()
    arg = mockClient.request.mostRecentCall.args[0]

    expect(arg.port).toBe 443

  it 'should normalize headers to camelcase', ->
    obj = HttpRequest.prototype._normalizeObject {"ab-cd": "ef"}
    expect(obj).toEqual {"abCd": "ef"}
