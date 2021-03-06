describe Fastlane::FastfileParser do
  describe "Initializers" do
    it "only allows 1 param in the initializer" do
      expect {
        Fastlane::FastfileParser.new(path: "./examples/Fastfile1", file_content: "tacos")
      }.to (raise_exception)
    end

    it "properly parses when using the file_content initializer" do
      file_content = File.read("./examples/Fastfile2")

      fastfile = Fastlane::FastfileParser.new(file_content: file_content)
      tree = fastfile.tree
      expect(tree[:ios][:beta]).to be_kind_of(Hash)
      expect(tree[nil][:something]).to be_kind_of(Hash)
      expect(tree[:android][:lane1]).to be_kind_of(Hash)
      expect(tree[:android][:lane2]).to be_kind_of(Hash)
    end
  end

  describe "Sample Fastfile 1" do
    before do
      @fastfile = Fastlane::FastfileParser.new(path: "./examples/Fastfile1")
    end

    it "properly parses the `before_all` block without a platform" do
      expect(@fastfile.tree[nil][:_before_all_block_][:actions]).to eq([
        {
          action: :git_pull,
          parameters: {
            something: 123,
            something2: "value2"
          }
        },
        {
          action: :cocoapods,
          parameters: nil
        }
      ])
    end

    it "properly parses actions outside of all platforms and lanes" do
      expect(@fastfile.tree[nil][nil][:actions]).to eq([
        {
          action: :fastlane_version,
          parameters: '2.0.0'
        }
      ])
    end

    describe "private lane is public" do
      before do
        @helper_lane = @fastfile.tree[nil][:helper]
      end

      it "private lanes are private" do
        expect(@helper_lane[:private]).to eq(true)
      end
    end

    describe "properly parses the `beta` lane without a platform" do
      before do
        @beta_lane = @fastfile.tree[nil][:beta]
      end

      it "parses the description" do
        expect(@beta_lane[:description]).to eq(["Automatic Beta Deployment", "Multiple lines"])
      end

      it "public lanes are public" do
        expect(@beta_lane[:private]).to eq(false)
      end
      
      it "parses the actions with all their parameters" do
        actions = @beta_lane[:actions]

        expect(actions[0]).to eq({action: :sigh, parameters: nil})
        expect(actions[1]).to eq({advancedCode: "10.times do\n  yolo\nend"})
        expect(actions[2]).to eq({advancedCode: "if ((10 + 10) == 100)\n  while something\n    puts(\"hi\")\n  end\nend"})
        expect(actions[3]).to eq({action: :gym, parameters: { scheme: "Example", force: true }})
        expect(actions[4]).to eq({action: :snapshot, parameters: { number_of_retries: 25 }})
        expect(actions[5]).to eq({action: :snapshot, parameters: { number_of_retries: 25.12 }})
      end
    end
  end

  describe "Sample Fastfile 2" do
    before do
      @fastfile = Fastlane::FastfileParser.new(path: "./examples/Fastfile2")
    end

    # This test is just one big test, so to debug the specific issue, better use the tests above
    it "parses all the available lanes correctly" do
      tree = @fastfile.tree
      expect(tree[:ios][:beta]).to be_kind_of(Hash)
      expect(tree[nil][:something]).to be_kind_of(Hash)
      expect(tree[:android][:lane1]).to be_kind_of(Hash)
      expect(tree[:android][:lane2]).to be_kind_of(Hash)
    end
  end

  describe "Sample Fastfile 3 (simple)" do
    before do
      @fastfile = Fastlane::FastfileParser.new(path: "./examples/Fastfile3")
    end

    it "works with lanes without platform" do
      tree = @fastfile.tree
      expect(tree[nil][:test]).to eq({:description=>[], :actions=>[{:action=>:no_u, :parameters=>nil}], :private=>false})
      expect(tree[nil][:test_arguments]).to eq({:description=>[], :actions=>[{:action=>:no_u_3, :parameters=> {:argument => "hello" } }], :private=>false})
      expect(tree[nil][:test2]).to eq({:description=>[], :actions=>[{:action=>:no_u_2, :parameters=>nil}], :private=>false})
    end
  end

  describe "Sample Fastfile 4 (simple)" do
    before do
      @fastfile = Fastlane::FastfileParser.new(path: "./examples/Fastfile4")
    end

    it "works with lanes without platform" do
      tree = @fastfile.tree
      expect(tree[:ios].keys).to eq([:test])
    end
  end

  describe "Sample Fastfile 5 (complex)" do
    before do
      @fastfile = Fastlane::FastfileParser.new(path: "./examples/Fastfile5")
    end

    it "works with lanes without platform" do
      tree = @fastfile.tree
      expect(tree[nil].keys).to eq([nil, :_before_all_block_, :ship_beta, :_error_block_])
    end
  end
end
