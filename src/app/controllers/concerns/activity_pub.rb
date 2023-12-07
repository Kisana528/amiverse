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
    headers = sign_headers body, name_id, 'amiverse.net', host, private_key
    req,res = https_post(
      host,
      headers,
      body.to_json
    )
    # 検証開始
    #result = verify_signature(public_key, sign, to_be_signed)
    Rails.logger.info('-----結果発表------')
    Rails.logger.info(res.body)
    Rails.logger.info('-----内容は------')
    Rails.logger.info(body.to_json)
    Rails.logger.info('-----headersは------')
    Rails.logger.info(headers)
    # 検証終了
    ActivityPubDelivered.create(
      host: host,
      content: body.to_json,
      response: res.body)
  end
  def post_activity(req, body, headers)
    puts "POST #{req} #{body.to_json}"
    HTTP[headers].post(req, json: body)
    nil
  end
  def sign_headers(body, str_name, str_host, str_inbox, private_key)
    str_time = Time.now.utc.httpdate
    s256 = Digest::SHA256.base64digest(body.to_json)
    private_key = OpenSSL::PKey::RSA.new(private_key)
    sig = private_key.sign(OpenSSL::Digest::SHA256.new, [
      "(request-target): post #{URI.parse(str_inbox).path}",
      "host: #{URI.parse(str_inbox).host}",
      "date: #{str_time}",
      "digest: SHA-256=#{s256}"
    ].join("\n"))
    b64 = Base64.strict_encode64(sig)
    headers = {
      Host: URI.parse(str_inbox).host,
      Date: str_time,
      Digest: "SHA-256=#{s256}",
      Signature: [
        "keyId=\"https://#{str_host}/@#{str_name}#Key\"",
        'algorithm="rsa-sha256"',
        'headers="(request-target) host date digest"',
        "signature=\"#{b64}\""
      ].join(','),
      Accept: 'application/json',
      'Accept-Encoding': 'gzip',
      'Cache-Control': 'max-age=0',
      'Content-Type': 'application/activity+json',
      'User-Agent': "test (+https://#{str_host}/)"
    }
    headers
  end
end