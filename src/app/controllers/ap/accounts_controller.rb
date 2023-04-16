class Ap::AccountsController < Ap::ApplicationController
  before_action :set_account, only: %i[ show inbox outbox followers following ]
  def show
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "Person",
      id: full_api_url("@#{@account.name_id}"),
      url: full_api_url("@#{@account.name_id}"),
      tag: [],
      published: @account.created_at,
      discoverable: true,
      attachment: [],
      manuallyApprovesFollowers: true,
      name: @account.name,
      summary: "",
      icon: {
        type: 'Image',
        mediaType: 'image/webp',
        url: ati(@account.account_id, 'icon', @account.icon_id)
      },
      preferredUsername: @account.name_id,
      inbox: full_api_url("ap/@#{@account.name_id}/inbox"),
      outbox: full_api_url("ap/@#{@account.name_id}/outbox"),
      followers: full_api_url("ap/@#{@account.name_id}/followers"),
      following: full_api_url("ap/@#{@account.name_id}/following")
    }
  end
  def inbox
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "OrderedCollection",
      id: full_api_url("ap/@#{@account.name_id}/inbox"),
      items: []
    }
  end
  def outbox
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "OrderedCollection",
      id: full_api_url("ap/@#{@account.name_id}/outbox"),
      items: []
    }
  end
  def followers
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "Collection",
      id: full_api_url("ap/@#{@account.name_id}/followers"),
      items: [],
      totalItems: 1
    }
  end
  def following
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "Collection",
      id: full_api_url("ap/@#{@account.name_id}/following"),
      items: [],
      totalItems: 1
    }
  end
  private
  def set_account
    @account = Account.find_by(
      name_id: params[:name_id],
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false
    )
  end
end