require 'rails_helper'

describe Post do 

  describe "associations" do

    before(:all) { @post = Post.new }

    it "has many comments" do
      expect(@post).to have_many(:comments).dependent(:destroy) 
    end
    
    it "has many votes" do
      expect(@post).to have_many(:votes).dependent(:destroy) 
    end

    it "has many favorites" do
      expect(@post).to have_many(:favorites).dependent(:destroy) 
    end

    it "belongs to user" do
      expect(@post).to belong_to(:user)
    end

    it "belongs to topic" do
      expect(@post).to belong_to(:topic)
    end
  
  end

  describe "validations" do

    before(:all) { @post = Post.new }

    it "validates title is at least 5 chars long" do
      expect(@post).to ensure_length_of(:title).is_at_least(5)
    end

    it "validates title is present" do
      expect(@post).to validate_presence_of(:title)
    end

    it "validates body is at least 20 chars long" do
      expect(@post).to ensure_length_of(:body).is_at_least(20)
    end

    it "validates body is present" do
      expect(@post).to validate_presence_of(:body)
    end

    it "validates topic is present" do
      expect(@post).to validate_presence_of(:topic)
    end

    it "validates user is present" do
      expect(@post).to validate_presence_of(:user)
    end

  end
  
  describe "vote methods" do

    before do
      @post = create(:post)
      3.times { @post.votes.create(value: 1) }
      2.times { @post.votes.create(value: -1) }
    end

    describe '#up_votes' do
      it "counts the number of votes with value = 1" do
        expect( @post.up_votes ).to eq(3)
      end
    end

    describe '#down_votes' do
      it "counts the number of votes with value = -1" do
        expect( @post.down_votes ).to eq(2)
      end
    end

    describe '#points' do
      it "returns the sum of all down and up votes" do
        expect( @post.points ).to eq(1) # 3 - 2
      end
    end
  end

  describe '#create_vote' do
    it "generates an up-vote when explicitly called" do
      post = create(:post)
      expect( post.up_votes ).to eq(0)
      post.create_vote
      expect( post.up_votes ).to eq(1)
    end
  end
end