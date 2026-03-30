# frozen_string_literal: true

module Legion
  module Extensions
    module Prompt
      module Runners
        module Prompt
          def create_prompt(name:, template:, description: nil, model_params: {}, **)
            now = Time.now.utc
            prompt_id = db[:prompts].insert(name: name, description: description, created_at: now, updated_at: now)
            hash = Helpers::TemplateRenderer.content_hash(template, model_params)
            db[:prompt_versions].insert(
              prompt_id: prompt_id, version: 1, template: template,
              model_params: serialize_params(model_params), content_hash: hash, created_at: now
            )
            { created: true, name: name, version: 1, prompt_id: prompt_id }
          end

          def update_prompt(name:, template:, model_params: {}, **)
            prompt = db[:prompts].where(name: name).first
            return { error: 'not_found' } unless prompt

            hash = Helpers::TemplateRenderer.content_hash(template, model_params)
            latest = db[:prompt_versions].where(prompt_id: prompt[:id]).order(Sequel.desc(:version)).first
            return { updated: false, reason: 'no_change' } if latest && latest[:content_hash] == hash

            new_version = (latest ? latest[:version] : 0) + 1
            db[:prompt_versions].insert(
              prompt_id: prompt[:id], version: new_version, template: template,
              model_params: serialize_params(model_params), content_hash: hash, created_at: Time.now.utc
            )
            db[:prompts].where(id: prompt[:id]).update(updated_at: Time.now.utc)
            { updated: true, name: name, version: new_version }
          end

          def get_prompt(name:, version: nil, tag: nil, **)
            prompt = db[:prompts].where(name: name).first
            return { error: 'not_found' } unless prompt

            pv = resolve_version(prompt[:id], version: version, tag: tag)
            return { error: 'version_not_found' } unless pv

            { name: name, version: pv[:version], template: pv[:template],
              model_params: deserialize_params(pv[:model_params]),
              content_hash: pv[:content_hash], created_at: pv[:created_at] }
          end

          def list_prompts(**)
            db[:prompts].all.map do |prompt|
              latest = db[:prompt_versions].where(prompt_id: prompt[:id]).order(Sequel.desc(:version)).first
              { name: prompt[:name], description: prompt[:description],
                latest_version: latest ? latest[:version] : nil, updated_at: prompt[:updated_at] }
            end
          end

          def tag_prompt(name:, tag:, version: nil, **)
            prompt = db[:prompts].where(name: name).first
            return { error: 'not_found' } unless prompt

            pv = resolve_version(prompt[:id], version: version)
            return { error: 'version_not_found' } unless pv

            db[:prompt_tags].insert_conflict(target: %i[prompt_id tag], update: { version_id: pv[:id] })
                            .insert(prompt_id: prompt[:id], tag: tag, version_id: pv[:id], created_at: Time.now.utc)
            { tagged: true, name: name, tag: tag, version: pv[:version] }
          end

          def render_prompt(name:, variables: {}, version: nil, tag: nil, **)
            pv = get_prompt(name: name, version: version, tag: tag)
            return pv if pv[:error]

            rendered = Helpers::TemplateRenderer.render(pv[:template], variables: variables)
            { rendered: rendered, prompt_version: pv[:version] }
          end

          private

          def resolve_version(prompt_id, version: nil, tag: nil)
            if tag
              tag_row = db[:prompt_tags].where(prompt_id: prompt_id, tag: tag).first
              tag_row ? db[:prompt_versions].where(id: tag_row[:version_id]).first : nil
            elsif version
              db[:prompt_versions].where(prompt_id: prompt_id, version: version).first
            else
              db[:prompt_versions].where(prompt_id: prompt_id).order(Sequel.desc(:version)).first
            end
          end

          def serialize_params(params)
            return '{}' if params.nil? || params.empty?

            ::JSON.dump(params)
          end

          def deserialize_params(raw)
            return {} if raw.nil? || raw.empty? || raw == '{}'

            result = ::JSON.parse(raw)
            result.is_a?(Hash) ? result.transform_keys(&:to_sym) : {}
          rescue ::JSON::ParserError => _e
            {}
          end

          def db
            @db
          end
        end
      end
    end
  end
end
