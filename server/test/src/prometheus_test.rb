require_relative 'zipper_test_base'
require 'prometheus/client'
require 'prometheus/client/push'

class PrometheusTest < ZipperTestBase

  def self.hex_prefix; '014'; end

  test 'AD1','smoke test' do
    # http://www.rubydoc.info/gems/prometheus-client/0.4.2
    prometheus = Prometheus::Client.registry
    refute_nil prometheus
    zip_counter = prometheus.counter(:zip_total, 'zip request counter')
    refute_nil zip_counter
    assert_equal 0, zip_counter.get
    zip_counter.increment
    assert_equal 1, zip_counter.get

    r = Prometheus::Client::Push.new(
      'my_job', 'instance_name', 'http://prometheus_pushgateway:9091').replace(prometheus)
    refute_nil r
  end

end
