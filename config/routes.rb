NinetyNineCatsDay1::Application.routes.draw do
  resources :cats, except: :destroy
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:create, :new, :index]
  resources :cat_rental_requests, only: [:create, :new] do
    # we chose post. Patch might be semantically better
    # but now we don't need that extra hidden input to send
      # params {_method: 'patch'}

    post "approve", on: :member
    post "deny", on: :member
  end

  root to: redirect("/cats")
end
