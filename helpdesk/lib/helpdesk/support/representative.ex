defmodule Helpdesk.Support.Representative do
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "representatives"
    repo Helpdesk.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :num]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
    end

    attribute :num, :integer
  end

  aggregates do
    exists :subject_issue_6, :tickets do
      filter expr(subject == "Issue 4")
    end

    count :count_of_tickets, :tickets

    list :list_of_open_tickets, :tickets, :status do
      filter expr(status == "open")
    end

    first :matching_value_for_subject, :tickets, :status do
      filter expr(like(status, "closed"))
    end
  end

  relationships do
    has_many :tickets, Helpdesk.Support.Ticket
  end
end
