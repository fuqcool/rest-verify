HttpRequest = require './http'

req = new HttpRequest

req.hostname = 'net4.ccs.neu.edu'
req.path = '/home/fuqcool/blueos/rest/app'
req.execute (data) -> console.log data

