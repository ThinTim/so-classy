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

      it 'should return status 201' do
        post :create, skill: {
            name: 'Knitting'
        }

        expect(response.status).to eq 201
      end

      it 'should store the new skill' do
        post :create, skill: {
            name: 'Knife Fighting'
        }

        expect(Skill.find_by_name('Knife Fighting')).to_not be_nil
      end

    end

    context 'when the skill already exists' do

      before(:each) do
        Skill.create({ name: 'Duplicating' })
      end

      it 'should return status 200' do
        post :create, skill: {
            name: 'Duplicating'
        }

        expect(response.status).to eq 200
      end

      it 'should not create a duplicate skill' do
        size_after_first_post = Skill.all.size

        post :create, skill: {
            name: 'Duplicating'
        }

        expect(Skill.all.size).to eq size_after_first_post
      end

    end

  end

end
