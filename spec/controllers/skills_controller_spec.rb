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

    context 'when skill is new' do

      it 'should store the new skill' do
        post :create, skill: {
            name: 'Knife fighting'
        }

        expect(assigns(:skill).name).to eq 'Knife fighting'
      end

      it 'should redirect to the new skill' do
        post :create, skill: {
            name: 'Knife knitting'
        }

        assert_redirected_to assigns(:skill)
      end

    end

    context 'when skill already exists' do

      before(:each) do
        @existing_skill = Skill.create({ name: 'Duplicating' })
      end

      it 'should redirect the user to the skill' do
        post :create, skill: {
            name: 'Duplicating'
        }

        assert_redirected_to(@existing_skill) 
      end

      it 'should not create a duplicate skill' do
        assert_difference 'Skill.count', 0 do
          post :create, skill: { name: 'Duplicating' }
        end
      end

    end

  end

  describe 'GET #show' do

    let(:skill) { Skill.create({ name: 'Banjo' }) }
    
    it 'should make the skill available' do
      get :show, id: skill.id

      expect(assigns(:skill)).to eq skill
    end

  end

end
