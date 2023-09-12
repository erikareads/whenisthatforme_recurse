defmodule WhenisthatformeRecurse do
  @moduledoc """
  Documentation for `WhenisthatformeRecurse`.
  """

  require OpenTelemetry.Tracer, as: Tracer

  @doc """
  Hello world.

  ## Examples

      iex> WhenisthatformeRecurse.hello()
      :world

  """
  def hello do
    Tracer.with_span :operation do
      Tracer.add_event("Nice operation!", [{"bogons", 100}])
      Tracer.set_attributes([{:another_key, "yes"}])

      Tracer.with_span "Sub operation..." do
        Tracer.set_attributes([{:lemons_key, "five"}])
        Tracer.add_event("Sub span event!", [])
      end
    end
  end
end
