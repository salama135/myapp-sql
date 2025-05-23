module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # Elasticsearch::Model::Callbacks are usually included for automatic indexing on save/update.
    # If they are not desired for MessageModel (e.g. if indexing is handled differently),
    # this could be reviewed, but for now, assume it's intended to be there.
    include Elasticsearch::Model::Callbacks 

    # Define custom settings and mappings for Elasticsearch
    settings index: {
      analysis: {
        analyzer: {
          ngram_content_analyzer: {
            type: 'custom',
            tokenizer: 'ngram_tokenizer',
            filter: ['lowercase']
          }
        },
        tokenizer: {
          ngram_tokenizer: {
            type: 'ngram',
            min_gram: 2, # Adjust min_gram as needed
            max_gram: 20, # Adjust max_gram as needed
            token_chars: ['letter', 'digit']
          }
        }
      }
    } do
      mappings dynamic: 'false' do # Be explicit about dynamic mapping if not needed
        indexes :body, type: 'text', analyzer: 'ngram_content_analyzer'
        indexes :chat_model_id, type: 'keyword' # Important for exact term filtering
      end
    end

    def self.search(query, chat_id)
      elasticsearch_query = {
        query: {
          bool: {
            must: {
              match: { # Using match for a single field, multi_match is also fine
                body: {
                  query: query,
                  fuzziness: "AUTO"
                }
              }
            },
            filter: {
              term: {
                chat_model_id: chat_id
              }
            }
          }
        }
      }
      self.__elasticsearch__.search(elasticsearch_query)
    end
  end
end