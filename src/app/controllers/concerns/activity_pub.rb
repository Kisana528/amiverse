module ActivityPub
  def ap_follow(follow_to:, follow_from:, uid:)
    ap_send(
      id: "follow/#{uid}",
      type: 'Follow',
      actor: follow_from,
      object: follow_to.fediverse_id,
      destination: follow_to
    )
  end
  def undo_follow(follow_to:, follow_from:, uid:)
    undo_object = {
      "id": File.join(follow_from.fediverse_id, "follow/#{uid}"),
      "type": 'Follow',
      "actor": follow_from.fediverse_id,
      "object": follow_to.fediverse_id
    }
    ap_send(
      id: 'undo_follow',
      type: 'Undo',
      actor: follow_from,
      object: undo_object,
      destination: follow_to
    )
  end
  def accept_follow(received_body:, follow_to_account:, follow_from_account:)
    accept_object = {
      "id": received_body['id'],
      "type": 'Follow',
      "actor": follow_from_account.fediverse_id,
      "object": follow_to_account.fediverse_id
    }
    ap_send(
      id: 'accept_follow',
      type: 'Accept',
      actor: follow_to_account,
      object: accept_object,
      destination: follow_from_account
    )
  end
  def accept_undo_follow(received_body:, follow_to_account:, follow_from_account:)
    ap_send(
      id: 'undo_follow',
      type: 'Accept',
      actor: follow_to_account,
      object: received_body,
      destination: follow_from_account
    )
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
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "cc": [
          "https://mstdn.jp/users/kisana",
          "https://misskey.io/users/9arqrxdfco",
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
  end
  def delete_note()
  end
  def ap_send(id:, type:, actor:, object:, destination:)
    body = {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": type,
      "id": File.join(actor.fediverse_id, id),
      "actor": actor.fediverse_id,
      "object": object
    }
    deliver(
      body: body,
      name_id: actor.name_id,
      private_key: actor.private_key,
      to_url: File.join(destination.fediverse_id, 'inbox')
    )
  end
  def read(data)
    body = JSON.parse(data['body'])
    headers = data['headers']
    context = body['@context']
    id = body['id']
    object = body['object'] unless body['object'].nil?
    #--- Info ---
    # 0:処理開始
    # 1:内部処理完了、これから結果を配送
    #--- Success ---
    # 0:正常に完了
    #--- Error ---
    # 0:Actorが存在しない
    # 1:すでにフォロー済み
    # 2:フォロー出来なかった
    # 3:フォロー先アカウントが不明
    # 4:フォローしていないので解除できない
    # 5:フォロー解除先アカウントが不明
    # 6:フォローアクセプト受け取ったが処理できない
    status = 'I0'
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
    saved_data = ActivityPubReceived.create!(received_params)
    ########
    # 解析 #
    ########
    if account = account(body['actor'])
      case body['type']
      when 'Follow'
        if follow_to_account = account(object)
          this_follow_params = {
            follow_to_id: follow_to_account.account_id,
            follow_from_id: account.account_id,
            uid: id,
            accepted: true
          }
          if Follow.exists?(this_follow_params)
            status = 'E1'
          elsif Follow.create!(this_follow_params)
            status = 'I1'
            # 鍵垢でなければすぐにAcceptを返却
            accept_follow(
              received_body: body,
              follow_to_account: follow_to_account,
              follow_from_account: account
            )
            status = 'S0'
          else
            status = 'E2'
          end
        else
          status = 'E3'
        end
      when 'Like'
        #actorがobjectをいいねする
      when 'Dislike'
      ## リアクション系
      when 'Accept'
        case object['type']
        when 'Follow'
          follow_to = account(object['object'])
          follow_from = account(object['actor'])
          this_follow_params = {
            follow_to_id: account(object['object']).account_id,
            follow_from_id: account(object['actor']).account_id,
            uid: object['id']
          }
          follow = Follow.find_by(this_follow_params)
          follow.accepted = true
          if follow.save!
            status = 'S0'
          else
            status = 'E6'
          end
        when 'Undo'
          Rails.logger.info('----------')
          Rails.logger.info('-----Undo-----')
          case object['object']['type']
          when 'Follow'
            Rails.logger.info('-----Undo---Follow--')
            #Follow.where(this_follow_params).delete_all
          else
          end
        else
        end
      when 'Reject'
      when 'Undo'
        case object['type']
        when 'Follow'
          if follow_to_account = account(object['object'])
            this_follow_params = {
              follow_to_id: follow_to_account.account_id,
              follow_from_id: account.account_id
            }
            if Follow.exists?(this_follow_params)
              Follow.where(this_follow_params).delete_all
              status = 'S0'
            else
              status = 'E4'
            end
          else
            status = 'E5'
          end
        else
          #その他
        end
      ## CRUD系
      when 'Create'
        #actorアカウントがあるか確認
        case object['type']
        when 'Note'
          attributed_to = account(object['attributedTo'])
          @item = Item.new(
            content: object['content'].force_encoding('UTF-8'),
            cw: object['sensitive']
          )
          @item.account_id = attributed_to.id
          @item.item_id = unique_random_id(Item, 'item_id')
          @item.uuid = SecureRandom.uuid
          @item.item_type = 'plane'
          if @item.save
            status = 'S0'
          end
        else
          #その他
        end
        #objectを作成する
      when 'Update'
      when 'Delete'
      else
        #その他
      end
    else
      status = 'E0'
    end
    # status更新
    saved_data.status = status
    saved_data.save
    return status
  end
  def server(host)
    unless server = ActivityPubServer.find_by(host: host)
      server = explore_server(host)
    end
    return server
  end
  def explore_server(host)
    uri_0 = URI::HTTPS.build(
      host: host,
      path: '/.well-known/nodeinfo'
    )
    req_0,res_0 = https_get(
      uri_0.to_s,
      {'Accept': 'application/json'}
    )
    nodeinfo = JSON.parse(res_0.body)['links'].select { |link| link['rel'] == "http://nodeinfo.diaspora.software/ns/schema/2.0" }
    href = nodeinfo['href']
    uri = URI::HTTPS.build(
      host: host,
      path: URI.parse(href).path
    )
    req,res = https_get(
      uri.to_s,
      {'Accept': 'application/json'}
    )
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
    ActivityPubServer.create(server_params)
  end
  def id_to_uri(id)
    name_id, host, own_server = name_id_host_separater(id)
    uri = ''
    if own_server
    else
      uri = URI::HTTPS.build(
        host: host,
        path: '/.well-known/webfinger',
        query: 'resource=acct:' + name_id + '@' + host
      )
      req,res = https_get(
        uri.to_s,
        {}
      )
      data = JSON.parse(res.body)
      self_links = data['links'].select { |link| link['rel'] == "self" }
      uri = self_links.first['href']
    end
    return uri
  end
  def account(uri)
    #サーバー判定
    if URI.parse(uri).host == URI.parse(ENV['APP_HOST']).host
      account = Account.find_by(name_id: uri.split(/[@]/).last)
    else
      server = server(URI.parse(uri).host)
      #アカウントあるかないか
      account = Account.find_by(fediverse_id: uri)
    end
    return account
  end
  def explore_account(uri)
    #server確認紐づけ
    req,res = https_get(
      uri,
      {'Accept' => 'application/activity+json'}
    )
    res.code == 200
    data = JSON.parse(res.body)
    account = Account.new(
      name: data['name'].present? ? data['name'] : '',
      name_id: get_name_id(data['id'], data['preferredUsername']),
      account_id: unique_random_id(Account, 'account_id'),
      fediverse_id: uri,
      #serverと紐づけ
      outsider: true,
      activated: true,
      bio: data['summary'].present? ? data['summary'] : '',
      explorable: data['discoverable'].nil? ? true : data['discoverable'].present?,
      locked: data['manuallyApprovesFollowers'].nil? ? true : data['manuallyApprovesFollowers'].present?,
      public_key: data['publicKey']['publicKeyPem']
    )
    account.save!(context: :skip)
  end
  def deliver(
      body:,
      name_id:,
      private_key:,
      from_url: ENV['APP_HOST'],
      to_url:
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
      "(request-target): post #{URI.parse(to_url).path}",
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