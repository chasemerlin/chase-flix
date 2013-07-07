require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to queue items of the logged in user" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      queue_item1 = Fabricate(:queue_item, user: susan)
      queue_item2 = Fabricate(:queue_item, user: susan)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it "redirects to the sign in page if user is unauthenticated" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item associated with the current user" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(susan)
    end

    it "places the video in the last position in the queue" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: susan)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park, user_id: susan).first
      expect(south_park_queue_item.position).to eq(2)
    end

    it "does not add video to queue if video is already in the queue" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: susan)
      post :create, video_id: monk.id
      expect(susan.queue_items.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      queue_item = Fabricate(:queue_item, user: susan)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      queue_item1 = Fabricate(:queue_item, user: susan, position: 1)
      queue_item2 = Fabricate(:queue_item, user: susan, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not in the current user queue" do
      susan = Fabricate(:user)
      session[:user_id] = susan.id
      charlie = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: charlie)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: 2
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST update_queue" do
    
    context "with valid inputs" do
      
      let(:susan) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: susan, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: susan, position: 2, video: video) }
      
      before do
        session[:user_id] = susan.id
      end
      
      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(susan.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(susan.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    
    context "with invalid inputs" do
      
      let(:susan) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: susan, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: susan, position: 2, video: video) }
      
      before do
        session[:user_id] = susan.id
      end

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end
      
      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end 
    
    context "with queue items that belong to another user" do
      
      it "does not change the queue items" do
        susan = Fabricate(:user)
        session[:user_id] = susan.id
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: susan, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end