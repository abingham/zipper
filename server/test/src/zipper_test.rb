require_relative 'zipper_test_base'
require_relative 'null_logger'
require_relative '../../src/id_splitter'

class ZipperTest < ZipperTestBase

  def self.hex_prefix; '03D'; end

  def log
    @log ||= NullLogger.new(self)
  end

  # TODO:
  # Use prepared volume mounted into storer.
  # Like I did for storer/server/git_kata
  # the volumes don't need git katas, only newer json katas
  # volume can be readonly
  # TODO:

  test 'BEC',
  'zip with empty id raises' do
    error = assert_raises(StandardError) { zip_json(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
    error = assert_raises(StandardError) { zip_git(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '849',
  'zip with bad id raises' do
    error = assert_raises(StandardError) { zip_json(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
    error = assert_raises(StandardError) { zip_git(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test '561',
  'download of empty dojo with no avatars',
  'untars to same as original folder' do
    prepare
    get 'downloader/download_json', 'id' => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1B1',
  'download of dojo with one avatar and one traffic-light',
  'untars to same as original folder' do
    prepare
    start
    kata_edit
    change_file('hiker.rb', 'def...')
    run_tests
    get 'downloader/download', 'id' => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E9B',
  'download of dojo with five animals and five traffic-lights',
  'untars to same as original folder' do
    prepare
    5.times do
      start
      kata_edit
      change_file('hiker.rb', 'def...')
      run_tests
      change_file('test_hiker.rb', 'def...')
      run_tests
    end
    get 'downloader/download', 'id' => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_downloaded
    assert_response :success
    # unzip new tarfile
    tarfile_name = @tar_dir + '/' + "#{@id}.tgz"
    assert File.exists?(tarfile_name), "File.exists?(#{tarfile_name})"
    untar_path = @tar_dir + '/' + 'untar'
    `rm -rf #{untar_path}`
    `mkdir -p #{untar_path}`
    `cd #{untar_path} && cat #{tarfile_name} | tar xfz -`

    # new format dir exists for kata
    kata_path = "#{untar_path}/#{outer(@id)}/#{inner(@id)}"
    kata_dir = disk[kata_path]
    assert kata_dir.exists?, '1.kata_dir.exists?'
    assert kata_dir.exists?('manifest.json'), "2.kata_dir.exists?('manifest.json')"
    manifest = kata_dir.read_json('manifest.json')
    assert_equal storer.kata_manifest(@id), manifest, '3.manifests are the same'

    # new format dir exists for each avatar
    katas[@id].avatars.each do |avatar|
      avatar_path = "#{kata_path}/#{avatar.name}"
      avatar_dir = disk[avatar_path]
      assert avatar_dir.exists?, '4.avatar_dir.exists?'
      assert avatar_dir.exists?('increments.json'), "5.avatar_dir.exists?('increments.json')"
      rags = avatar_dir.read_json('increments.json')
      # new format dir exists for each tag
      (1..rags.size).each do |tag|
        tag_path = "#{avatar_path}/#{tag}"
        tag_dir = disk[tag_path]
        assert tag_dir.exists?, '6. tag_dir.exists?'
        assert tag_dir.exists?('manifest.json'), "7.tag_dir.exists?('manifest.json')"
        expected = storer.tag_visible_files(@id, avatar.name, tag)
        actual = tag_dir.read_json('manifest.json')
        assert_equal expected, actual, '8.manifests are the same'
      end
    end
  end
=end

  private

  include IdSplitter

end
