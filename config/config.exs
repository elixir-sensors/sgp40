# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
# SPDX-FileCopyrightText: 2025 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0
#
import Config

if Mix.env() == :test do
  config :sgp40, transport_mod: SGP40.MockTransport
end
