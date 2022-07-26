# frozen_string_literal: true

json.array! @results, partial: 'tickets/ticket', as: :ticket
