import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:managment/providers/settings_provider.dart';
import 'package:managment/theme/app_colors.dart';
import 'package:managment/utils/constants.dart';
import 'package:managment/widgets/glassmorphism.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Appearance',
            [
              _buildThemeSelector(context),
              _buildFontSizeSlider(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Regional',
            [
              _buildCurrencySelector(context),
              _buildDateFormatSelector(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'About',
            [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: Text(DeveloperInfo.appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.smartphone),
                title: const Text('App Name'),
                subtitle: Text(AppInfo.appName),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Developer',
            [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Name'),
                subtitle: Text(DeveloperInfo.name),
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Role'),
                subtitle: Text(DeveloperInfo.role),
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('GitHub'),
                subtitle: Text(DeveloperInfo.github),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () {
                  // URL launcher can be integrated here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Visit: ${DeveloperInfo.githubUrl}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.facebook),
                title: const Text('Facebook'),
                subtitle: Text(DeveloperInfo.facebook),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () {
                  // URL launcher can be integrated here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Visit: ${DeveloperInfo.facebookUrl}')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showResetDialog(context),
            icon: const Icon(Icons.restore),
            label: const Text('Reset to Defaults'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Column(
          children: [
            RadioListTile<String>(
              title: const Text('Light Mode'),
              value: 'light',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.light_mode),
            ),
            RadioListTile<String>(
              title: const Text('Dark Mode'),
              value: 'dark',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'system',
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.brightness_auto),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFontSizeSlider(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('Font Size'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: settings.fontSize,
                min: 12,
                max: 20,
                divisions: 8,
                label: settings.fontSize.toStringAsFixed(0),
                onChanged: (value) {
                  settings.setFontSize(value);
                },
              ),
              Text('Preview text at ${settings.fontSize.toStringAsFixed(0)}pt'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencySelector(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Currency'),
          subtitle: Text('${settings.currency} (${settings.currencySymbol})'),
          onTap: () => _showCurrencyDialog(context, settings),
        );
      },
    );
  }

  Widget _buildDateFormatSelector(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date Format'),
          subtitle: Text(settings.dateFormat),
          onTap: () => _showDateFormatDialog(context, settings),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Currencies.currencies.length,
            itemBuilder: (context, index) {
              final currency = Currencies.currencies[index];
              final code = currency['code']!;
              final symbol = currency['symbol']!;
              final name = currency['name']!;

              return RadioListTile<String>(
                title: Text('$name ($symbol)'),
                subtitle: Text(code),
                value: code,
                groupValue: settings.currency,
                onChanged: (value) {
                  if (value != null) {
                    settings.setCurrency(value, symbol);
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDateFormatDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DateFormats.formats.map((format) {
            return RadioListTile<String>(
              title: Text(format),
              value: format,
              groupValue: settings.dateFormat,
              onChanged: (value) {
                if (value != null) {
                  settings.setDateFormat(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text('This will reset all settings to their default values.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsProvider>().resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
