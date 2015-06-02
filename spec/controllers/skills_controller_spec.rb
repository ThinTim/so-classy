require 'rails_helper'

describe SkillsController, type: :controller do

  describe 'GET #index' do

    it 'should return status 200' do
      get :index

      expect(response.status).to eq 200
    end

    it 'should list all skills' do
      testing_skill = Skill.create

      get :index

      expect(assigns(:skills)).to include testing_skill
    end

  end

  describe 'GET #new' do

    it 'should return status 200' do
      get :new

      expect(response.status).to eq 200
    end

  end

  describe 'POST #create' do

    describe 'when successful' do

      xit 'should return status 201' do
        post :create, skill: {
            name: 'Knitting'
        }

        expect(response.status).to eq 201
      end

      xit 'should store the new skill' do
        post :create, skill: {
            name: 'Knife Fighting'
        }
      end

    end

    describe 'when the skill already exists' do
      it 'should return status ???' do

      end

      it 'should not store a duplicate skill' do

      end
    end

  end

end
