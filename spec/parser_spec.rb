describe Fastlane::Parser do
  describe "Sample Fastfile 1" do
    before do
      @fastfile = Fastlane::Parser.new(path: "./examples/Fastfile1")
    end

    it "properly parses the `before_all` block without a platform" do
      expect(@fastfile.tree[nil][:_before_all_block_][:actions]).to eq([
        {
          action: :git_pull,
          parameters: {}
      }])
    end

    it "properly parses actions outside of all platforms and lanes" do
      expect(@fastfile.tree[nil][nil][:actions]).to eq([
        {
          action: :fastlane_version,
          parameters: '2.0.0'
        }
      ])
    end

    describe "properly parses the `beta` lane without a platform" do
      before do
        @beta_lane = @fastfile.tree[nil][:beta]
      end

      it "parses the description" do
        expect(@beta_lane[:description]).to eq(["Automatic Beta Deployment", "Multiple lines"])
      end
      
      it "parses the actions with all their parameters" do
        expect(@beta_lane[:actions]).to eq([
          {
            action: :sigh,
            parameters: {}
          },
          {
            action: :gym,
            parameters: {
              scheme: "Example",
              force: true
            }
          }
        ])
      end
    end

    describe "properly parses the `ios` platform" do
      before do
        @ios_platform = @fastfile.tree[:ios]
      end

      it "properly parses the `before_all` block for the `ios` platform" do
        expect(@ios_platform[:_before_all_block_][:actions]).to eq([
          {
            action: :cocoapods,
            parameters: {}
          }
        ])
      end

      it "properly parses the `appstore` lane in the `ios` platform" do
        expect(@ios_platform[:appstore][:actions]).to eq([
          {
            action: :slack,
            parameters: {
              something: true
            }
          }
        ])
      end

      it "properly parses the `after_all` block for the `ios` platform" do
        expect(@ios_platform[:_after_all_block_][:actions]).to eq([
          {
            action: :slack,
            parameters: {}
          }
        ])
      end

      it "properly parses the `error` block for the `ios` platform" do
        expect(@ios_platform[:_error_block_][:actions]).to eq([
          {
            action: :slack,
            parameters: {
              success: false
            }
          }
        ])
      end
    end
  end
end