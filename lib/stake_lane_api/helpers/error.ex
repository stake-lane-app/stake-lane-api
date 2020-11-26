defmodule StakeLaneApi.Helpers.Errors do
  def treated_error(message, status \\ :bad_request) do
    { :treated_error,
      %{
        message: message,
        status: status
      }
    }
  end
end
