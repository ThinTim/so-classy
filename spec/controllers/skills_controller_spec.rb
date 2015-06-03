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

    context 'when the skill is new' do

      it 'should store the new skill' do
        post :create, skill: {
            name: 'Knife Fighting'
        }

        expect(Skill.find_by_name('Knife Fighting')).to_not be_nil
      end

      it 'should redirect to the new skill' do
        post :create, skill: {
            name: 'Knife Knitting'
        }

        assert_redirected_to assigns(:skill)
      end

    end

    context 'when the skill already exists' do

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
    
    before(:each) do
      @existing_skill = Skill.create({ name: 'A Skill' })
    end

    it 'should make the skill available' do
      get :show, id: @existing_skill.id

      expect(assigns(:skill)).to eq @existing_skill
    end

  end

end
