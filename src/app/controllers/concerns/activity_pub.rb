module ActivityPub
  def create_note(item)
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": "Create",
      "id": "https://amiverse.net/items/#{item.item_id}/create",
      "published": item.created_at,
      "to": [
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
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
  end
  def deliver(body, private_key, name_id, host, path, public_key)
    body = body.to_json
    current_time = Time.now
    formatted_time = current_time.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
    digest = Digest::SHA256.base64digest(body) #hexdigest?
    to_be_signed = "(request-target): post /inbox\nhost: #{host}\ndate: #{formatted_time}\ndigest: sha-256=#{digest}"
    sign = generate_signature(to_be_signed, private_key)
    signature = 'keyId="https://amiverse.net/@' + name_id + '#main-key",algorithm="rsa-sha256",headers="(request-target) host date digest",signature="' + sign + '"'
    req,res = https_post(
      'https://' + host + path,
      { 'Content-Type' => 'application/activity+json',
        'Host' => host,
        'Date' => formatted_time,
        'Digest' => 'SHA-256=' + digest,
        'Signature' => signature
      },
      body
    )
    # 検証開始
    result = verify_signature(public_key, sign, to_be_signed)
    Rails.logger.info('-----結果発表------')
    Rails.logger.info(result ? 'ok' : 'ng')
    Rails.logger.info('-----内容は------')
    Rails.logger.info(to_be_signed)
    Rails.logger.info('-----署名は------')
    Rails.logger.info(sign)
    # 検証終了
    ActivityPubDelivered.create(
      host: host,
      path: path,
      digest: digest,
      signature: signature,
      content: body,
      response: res.body)
  end
end