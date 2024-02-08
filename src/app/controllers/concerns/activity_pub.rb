module ActivityPub
  def follow()
  end
  def accept_follow(body:, account:)
    body = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "id": "https://amiverse.net/@#{account.name_id}/follow_accept",
      "type": "Accept",
      "actor": "https://amiverse.net/@#{account.name_id}",
      "object": body.to_json
    }
    deliver(
      body: body,
      name_id: name_id,
      private_key: account.private_key
    )
  end
  def undo_follow()
  end
  def like()
  end
  def undo_like()
  end
  def create_note(item:)
    body = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": "Create",
      "id": "https://amiverse.net/items/#{item.item_id}/create",
      "published": item.created_at,
      "to": [
        "https://mstdn.jp/users/kisana",
        "https://misskey.io/users/9arqrxdfco",
        "https://amiverse.net/#{item.account.name_id}/followers",
        "https://www.w3.org/ns/activitystreams#Public"
      ],
      "actor": "https://amiverse.net/#{item.account.name_id}",
      "object": {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Note",
        "id": "https://amiverse.net/items/#{item.item_id}",
        "url": "https://amiverse.net/items/#{item.item_id}",
        "published": item.created_at,
        "to": [
          "https://mstdn.jp/users/kisana",
          "https://misskey.io/users/9arqrxdfco",
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
    deliver(
      body: body,
      name_id: item.account.name_id,
      private_key: item.account.private_key
    )
  end
  def delete_note()
  end
  def read(data)
    body = JSON.parse(data['body'])
    headers = data['headers']
    context = body['@context']
    id = body['id']
    object = body['object'] unless body['object'].nil?
    status = 'Info:処理中。'
    ########
    # 記録 #
    ########
    received_params = {
      received_at: body['received_at'].to_s,
      headers: headers.to_json,
      body: body.to_json,
      context: context.to_json,
      fediverse_id: id.to_s,
      status: status
    }
    received_params[:object] = object.to_json if object.present?
    received_params[:activity_type] = body['type'].to_s if body['type'].present?
    ActivityPubReceived.create!(received_params)
    ########
    # 解析 #
    ########
    return 'Error:actorが存在しません。' unless account = account(body['actor'])
    case body['type']
    ## アカウント、投稿系
    when 'Follow'
      if follow_to_account = account(object)
        this_follow_params = {
          follow_to_id: follow_to_account.account_id,
          follow_from_id: account.account_id
        }
        if Follow.exists?(this_follow_params)
          #Follow.where(this_follow_params).delete_all
          status = 'Error:すでにフォロー済みかもしれません。'
        elsif Follow.create!(this_follow_params)
          status = 'Success:フォローしました。'
        else
          status = 'Error:フォローに失敗しました。'
        end
      else
        status = 'Error:objectが存在しません。'
      end
      # 鍵垢でなければすぐにAcceptを返却
      accept_follow(body: body, account: follow_to_account)
    when 'Like'
      #actorがobjectをいいねする
    when 'Dislike'
    ## リアクション系
    when 'Accept'
    when 'Reject'
    when 'Undo'
    ## CRUD系
    when 'Create'
      #actorアカウントがあるか確認
      #objectを作成する
    when 'Update'
    when 'Delete'
    else
      #その他
    end
    return status
  end
  def server(host)
    #あるかないか
    unless server = ActivityPubServer.find_by(host: host)
      #なければ作成する
      uri = URI::HTTPS.build(
        host: host,
        path: '/nodeinfo/2.0'
      )
      Rails.logger.info(uri.to_s)
      req,res = https_get(
        uri.to_s,
        {}
      )
      return unless res.code == 200
      data = JSON.parse(res.body)
      server_params = {
        server_id: unique_random_id(ActivityPubServer, 'server_id'),
        host: host
      }
      server_params[:name] = data['metadata']['nodeName'] if data['metadata']['nodeName'].present?
      server_params[:description] = data['metadata']['nodeDescription'] if data['metadata']['nodeDescription'].present?
      server_params[:software_name] = data['software']['name'] if data['software']['name'].present?
      server_params[:software_version] = data['software']['version'] if data['software']['version'].present?
      if data['metadata']['maintainer'].present?
        server_params[:maintainer_name] = data['metadata']['maintainer']['name'] if data['metadata']['maintainer']['name'].present?
        server_params[:maintainer_email] = data['metadata']['maintainer']['email'] if data['metadata']['maintainer']['email'].present?
      end
      server_params[:open_registrations] = data['openRegistrations'] if data['openRegistrations'].present?
      server_params[:theme_color] = data['metadata']['themeColor'] if data['metadata']['themeColor'].present?
      server = ActivityPubServer.create(server_params)
    end
    #サーバーobj返却
    return server
    rescue
      return nil
  end
  def account(uri)
    #サーバー判定
    if URI.parse(uri).host == URI.parse(ENV['APP_HOST']).host
      account = Account.find_by(name_id: uri.split(/[@]/).last)
    else
      return unless server = server(URI.parse(uri).host)
      #アカウントあるかないか
      unless account = Account.find_by(fediverse_id: uri)
        #なければ作成する
        Rails.logger.info(uri.to_s)
        req,res = https_get(
          uri,
          {'Accept' => 'application/activity+json'}
        )
        return unless res.code == 200
        data = JSON.parse(res.body)
        account = Account.new(
          name: data['name'],
          name_id: get_name_id(data['id'], data['preferredUsername']),
          account_id: unique_random_id(Account, 'account_id'),
          fediverse_id: uri,
          #serverと紐づけ
          outsider: true,
          activated: true,
          bio: data['summary'],
          explorable: data['discoverable'],
          locked: data['manuallyApprovesFollowers'],
          public_key: data['publicKey']['publicKeyPem']
        )
        account.save!(context: :skip)
      end
    end
    return account
    rescue
      return nil
  end
  def deliver(
      body:,
      name_id:,
      private_key:,
      from_url: 'https://amiverse.net',
      to_url: 'https://mstdn.jp/inbox'
    )
    headers, digest, to_be_signed, sign, statement = sign_headers(body, name_id, private_key, from_url, to_url)
    req,res = https_post(
      to_url,
      headers,
      body.to_json
    )
    ActivityPubDelivered.create(
      to_url: to_url,
      digest: digest,
      to_be_signed: to_be_signed,
      signature: sign,
      statement: statement,
      content: body.to_json,
      response: res.body)
  end
  def front_deliver(body, name_id, private_key, from_url, to_url, public_key)
    headers, digest, to_be_signed, sign, statement = sign_headers(body, name_id, private_key, from_url, to_url)
    req,res = http_post(
      'http://front:3000/outbox',
      {Authorization: 'Bearer token-here',
      'Content-Type' => 'application/json'
      },{
      to_url: to_url,
      headers: headers,
      body: body}.to_json
    )
    ActivityPubDelivered.create(
      to_url: to_url,
      digest: digest,
      to_be_signed: to_be_signed,
      signature: sign,
      statement: statement,
      content: body.to_json,
      response: res.body)
  end
  def sign_headers(body, name_id, private_key, from_url, to_url)
    from_host = URI.parse(from_url).host
    to_host = URI.parse(to_url).host
    current_time = Time.now.utc.httpdate
    digest = Digest::SHA256.base64digest(body.to_json)
    to_be_signed = [
      "(request-target): post /inbox",
      "host: #{to_host}",
      "date: #{current_time}",
      "digest: SHA-256=#{digest}",
      "content-type: application/activity+json"].join("\n")
    sign = generate_signature(to_be_signed, private_key)
    statement = [
      "keyId=\"https://#{from_host}/@#{name_id}#main-key\"",
      'algorithm="rsa-sha256"',
      'headers="(request-target) host date digest content-type"',
      "signature=\"#{sign}\""
    ].join(',') # content-lengthも必要?
    headers = {
      Host: to_host,
      Date: current_time,
      Digest: "SHA-256=#{digest}",
      Signature: statement,
      Authorization: "Signature #{statement}",
      #Accept: 'application/json',
      #'Accept-Encoding': 'gzip',
      #'Cache-Control': 'max-age=0',
      'Content-Type': 'application/activity+json',
      'User-Agent': "Amiverse v0.0.1 (+https://#{from_host}/)"
    }
    return headers, digest, to_be_signed, sign, statement
  end
  def check_sign(body,a)
    digest = Digest::SHA256.base64digest(body.to_json)
    received_digest = data['headers']['digest'].split('=')[1]
    signature = data['headers']['signature']
    segments = signature.split(',')
    obj_segments = {}
    segments.each do |segment|
      key, value = segment.split('=')
      key = key.gsub('"', '').strip
      value = value.gsub('"', '').strip
      obj_segments[key] = value
    end
  end
  def get_name_id(uri, preferredUsername)
    host = URI.parse(uri).host
    preferredUsername + '@' + host
  end
end