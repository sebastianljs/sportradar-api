module Sportradar
  module Api
    class Ncaafb
      class Drive < Data
        attr_accessor :response, :id, :sequence, :start_reason, :end_reason, :play_count, :duration, :first_downs, :gain, :penalty_yards, :scoring_drive, :quarter, :team, :plays, :events

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @game     = opts[:game] # scoring drives directly from game via boxscore
          @quarter  = opts[:quarter] || response['quarter'] # via pbp as Quarter || via scoring_drives as number

          @id       = response['id']
          @clock    = response['clock']
          @team     = response['team']
          @sequence = response['sequence'] # via scoring_drives
          @score    = response['score']

          # @sequence = data["sequence"]
          # @start_reason = data["start_reason"]
          # @end_reason = data["end_reason"]
          # @play_count = data["play_count"]
          # @duration = data["duration"]
          # @first_downs = data["first_downs"]
          # @gain = data["gain"]
          # @penalty_yards = data["penalty_yards"]
          # @scoring_drive = data["scoring_drive"]
          # @quarter = Sportradar::Api::Nfl::Quarter.new data["quarter"] if data["quarter"]
          # @team = Sportradar::Api::Nfl::Team.new data["team"] if data["team"]
          # @plays = parse_into_array(selector: response["play"], klass: Sportradar::Api::Nfl::Play) if response["play"]
          # @plays ||= parse_into_array(selector: response["plays"]["play"], klass: Sportradar::Api::Nfl::Play) if response["plays"] && response["plays"]["play"]
          # @events = parse_into_array(selector: response["event"], klass: Sportradar::Api::Nfl::Event) if response["event"]
        end

        def plays
          @plays ||= parse_into_array_with_options(selector: response['play'], klass: Sportradar::Api::Ncaafb::Play, api: @api, drive: self)
        end


        def self.end_reason_possibilities
          [
            'UNKNOWN',
            'Touchdown',
            'Safety',
            'Field Goal',
            'Missed FG',
            'Blocked FG',
            'Blocked FG, Downs',
            'Blocked FG, Safety',
            'Punt',
            'Blocked Punt',
            'Blocked Punt, Downs',
            'Blocked Punt, Safety',
            'Downs',
            'Interception',
            'Fumble',
            'Fumble, Safety',
            'Muffed FG',
            'Muffed Punt',
            'Muffed Kickoff',
            'Kickoff',
            'Own Kickoff',
            'Onside Kick',
            'Kickoff, No Play',
            'End of Half',
            'End of Game',
          ]
        end
        def self.normalized_end_reason
          case end_reason
          when 'Touchdown'
            'Touchdown'
          when 'Field Goal'
            'Field Goal'
          when 'Downs'
            'Downs'
          when 'Interception', 'Fumble'
            'Turnover'
          when 'Punt'
            'Punt'
          else
            'Other'
          end
        end

      end
    end
  end
end
