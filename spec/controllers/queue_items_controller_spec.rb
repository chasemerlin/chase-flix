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
end