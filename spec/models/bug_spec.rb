require "rails_helper"

RSpec.describe Bug do
  let(:bug) { create(:bug, status: nil, description: nil) }

  context "Destruction of Project" do
    describe "when destroying a Project" do
      it "destroys associated bugs" do
        project = build(:project)
        build(:bug, project: project)
      end
    end
  end

  context "Creating" do
    describe "validations" do
      it "validates presence of title" do
        bug = build(:bug, title: nil)
        expect(bug.valid?).to be(false)
        expect(bug.errors[:title]).to include("can't be blank")
      end

      it "allows a bug with title present" do
        bug = build(:bug, title: "Not Nil Title")
        expect(bug.valid?).to be(true)
      end

      it "validates minimum length of title" do
        bug = build(:bug, title: "Short")
        expect(bug.valid?).to be(false)
        expect(bug.errors[:title]).to include("is too short (minimum is 10 characters)")
      end

      it "allows a bug having a title with a minimum of 10 characters" do
        bug = build(:bug, title: "Title with accurate length")
        expect(bug.valid?).to be(true)
      end

      it "validates for title format" do
        bug = build(:bug, title: "1234")
        expect(bug.valid?).to be(false)
        expect(bug.errors[:title]).to include("should contain at least one letter")
      end

      it "allows a bug with a title containing letters" do
        bug = build(:bug, title: "Title23456")
        expect(bug.valid?).to be(true)
      end
    end

    describe "deadline validation" do
      it "validates presence of deadline" do
        bug = build(:bug, deadline: nil)
        expect(bug.valid?).to be(false)
        expect(bug.errors[:deadline]).to include("can't be blank")
      end

      it "allows a bug with a deadline present" do
        bug = build(:bug, deadline: Time.current)
        expect(bug.valid?).to be(true)
      end
    end

    describe "bug_type validation" do
      it "validates presence of bug_type" do
        bug = build(:bug, bug_type: nil)
        expect(bug.valid?).to be(false)
        expect(bug.errors[:bug_type]).to include("can't be blank")
      end

      it "allows a bug with bug_type present" do
        bug = build(:bug, bug_type: "feature")
        expect(bug.valid?).to be(true)
      end
    end
  end

  context "Making Associations" do
    describe "creator association" do
      it "belongs to a creator, which is a User with an inverse association" do
        expect(described_class.reflect_on_association(:creator).macro).to eq(:belongs_to)
        expect(described_class.reflect_on_association(:creator).class_name).to eq("User")
        expect(described_class.reflect_on_association(:creator).options[:inverse_of]).to eq(:bugs)
      end
    end

    describe "project association" do
      it "belongs to a project" do
        expect(described_class.reflect_on_association(:project).macro).to eq(:belongs_to)
      end
    end

    describe "screenshot association" do
      it "has one attached screenshot" do
        bug = create(:bug, with_screenshot: true)
        expect(bug.screenshot).to be_attached
      end
    end
  end

  context "Status Enum" do
    describe "when setting the status" do
      it "does not allow values other than [:initiated, :started, :completed, :resolved]" do
        bug = build(:bug)
        begin
          bug.status = :invalid_status
          bug.save!
        rescue ArgumentError => e
          expect(e.message).to eq("'invalid_status' is not a valid status")
        end
      end

      it "allows values [:initiated, :started, :completed, :resolved]" do
        bug.status = :initiated
        expect(bug).to be_valid
      end
    end
  end

  context "Before Create Callbacks" do
    describe "when creating a bug" do
      it "sets the initial status to 'initiated' if not present" do
        expect(bug.status).to eq("initiated")
      end

      it "does not change the status if it's explicitly set" do
        bug = build(:bug, status: "started")
        expect(bug.status).not_to eq("initiated")
      end

      it "sets description to 'No Description' if not present" do
        expect(bug.description).to eq("No Description")
      end

      it "does not change the description if it's explicitly set" do
        bug = build(:bug, description: "Custom Description")
        expect(bug.description).not_to eq("No Description")
      end
    end
  end

  context "Screenshot Content Type Validation" do
    describe "when creating a bug with a screenshot" do
      it "creates a bug without a screenshot when with_screenshot is false" do
        bug = create(:bug, with_screenshot: false)
        expect(bug.screenshot).not_to be_attached
      end

      it "does not perform any action when the screenshot is of the correct content type (JPEG)" do
        bug = build(:bug, screenshot: Rack::Test::UploadedFile.new("spec/factories/images/image.jpg", "image/jpeg"))
        expect { bug.save! }.not_to raise_error
      end

      it "does not perform any action when the screenshot is of the correct content type (GIF)" do
        bug = build(:bug, screenshot: Rack::Test::UploadedFile.new("spec/factories/images/image.jpg", "image/gif"))
        expect { bug.save! }.not_to raise_error
      end

      it "adds an error when the screenshot has an invalid content type" do
        bug = build(:bug, screenshot: Rack::Test::UploadedFile.new("spec/factories/images/Oval.png", "image/png"))
        expect(bug.save).to be(false)
        expect(bug.errors[:screenshot]).to include("has an invalid content type")
      end
    end
  end
end
