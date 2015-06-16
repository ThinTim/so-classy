require 'rails_helper'

describe Topic, type: :model do
  describe 'popularity' do
    it 'should be the sum of unique teachers and students' do
      t = Topic.new(name: 'foo')
      u1 = User.new(email: 'picard@example.com')
      u2 = User.new(email: 'riker@example.com')

      expect(t.popularity).to eq 0

      t.students << u1

      expect(t.popularity).to eq 1

      t.teachers << u1

      expect(t.popularity).to eq 1

      t.teachers << u2

      expect(t.popularity).to eq 2
    end
  end

  describe 'members' do
    it 'should be the set union of teachers and students' do
      t = Topic.new(name: 'foo')
      u1 = User.new(email: 'picard@example.com')
      u2 = User.new(email: 'riker@example.com')

      expect(t.members).to eq []

      t.students << u1

      expect(t.members).to eq [u1]

      t.teachers << u1

      expect(t.members).to eq [u1]

      t.teachers << u2

      expect(t.members).to eq [u1, u2]
    end
  end
end
