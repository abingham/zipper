require_relative 'zipper_test_base'
require 'benchmark'
require 'prometheus/client'
require 'prometheus/client/push'

class PrometheusTest < ZipperTestBase

  def self.hex_prefix; '014'; end

  def log
    @log ||= NullLogger.new(self)
  end

  test 'AD1','histogram benchmark example' do
    # http://www.rubydoc.info/gems/prometheus-client/0.4.2
    prometheus = Prometheus::Client.registry
    refute_nil prometheus
    zip_seconds = prometheus.histogram(:zip_seconds, 'zip_request_seconds')
    refute_nil zip_seconds

    zip_seconds.observe({}, Benchmark.realtime { zip(started_kata_args[0][0]) })
    zip_seconds.observe({}, Benchmark.realtime { zip(started_kata_args[1][0]) })
    zip_seconds.observe({}, Benchmark.realtime { zip(started_kata_args[2][0]) })

    gateway = 'http://prometheus_pushgateway:9091'
    job = 'zip'
    instance = nil # '192.168.99.100'
    r = Prometheus::Client::Push.new(job, instance, gateway).add(prometheus)
    refute_nil r
    assert_equal '202', r.response.code
  end

end
