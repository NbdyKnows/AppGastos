import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/stream_providers.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';

/// Pantalla 1: Dashboard Principal (Ícono Casita ⌂)
/// Compendio de salud financiera con dos pestañas: "Inicio" y "A pagar".
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.fondo,
      appBar: AppBar(
        backgroundColor: colors.fondo,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: colors.textoPrimario),
            tooltip: 'Ajustes',
            onPressed: () => ctx.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer(),
          ),
        ),
        title: Text(
          'Inicio',
          style: TextStyle(
            color: colors.textoPrimario,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: colors.acento,
                  borderRadius: BorderRadius.circular(18),
                ),
                dividerColor: Colors.transparent,
                labelColor: colors.fondo,
                unselectedLabelColor: colors.textoSecundario,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                tabs: const [
                  Tab(text: 'Inicio'),
                  Tab(text: 'A pagar'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _InicioTabView(),
          _APagarTabView(),
        ],
      ),
    );
  }
}

/// Vista 1: Pestaña "Inicio"
class _InicioTabView extends ConsumerStatefulWidget {
  const _InicioTabView();

  @override
  ConsumerState<_InicioTabView> createState() => _InicioTabViewState();
}

class _InicioTabViewState extends ConsumerState<_InicioTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _openEdit(TransactionItem item) {
    AppRouter.toTransactionForm(
      context,
      isEditing: true,
      data: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = context.appColors;
    final saldoAsync = ref.watch(saldoDisponibleProvider);
    final ultimosMovimientosAsync = ref.watch(ultimosMovimientosProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta Gigante de Saldo Actual
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: colors.superficie,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.textoSecundario.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saldo Actual',
                      style: TextStyle(
                        color: colors.textoSecundario,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.acento.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Total Disponible',
                        style: TextStyle(
                          color: colors.acento,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                saldoAsync.when(
                  data: (saldo) => Text(
                    'S/ ${saldo.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colors.textoPrimario,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                    ),
                  ),
                  loading: () => SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: colors.acento,
                      ),
                    ),
                  ),
                  error: (e, st) => Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: colors.gasto, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Error al cargar saldo',
                        style: TextStyle(color: colors.gasto, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Título de sección "Últimos movimientos"
          Text(
            'Últimos movimientos',
            style: TextStyle(
              color: colors.textoPrimario,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          // Tarjeta de Últimos Movimientos
          ultimosMovimientosAsync.when(
            data: (txList) {
              if (txList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.superficie,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'No hay movimientos registrados',
                    style: TextStyle(color: colors.textoSecundario, fontSize: 14),
                  ),
                );
              }

              return Material(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: txList.length,
                  separatorBuilder: (ctx, i) => Divider(
                    color: colors.fondo.withValues(alpha: 0.5),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (ctx, index) {
                    final tx = txList[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (tx.isExpense ? colors.gasto : colors.ingreso).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          tx.isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          color: tx.isExpense ? colors.gasto : colors.ingreso,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        tx.title,
                        style: TextStyle(
                          color: colors.textoPrimario,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        tx.paymentMethod,
                        style: TextStyle(
                          color: colors.textoSecundario,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${tx.isExpense ? '-' : '+'} S/ ${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: tx.isExpense ? colors.textoPrimario : colors.ingreso,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colors.textoSecundario,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () => _openEdit(tx),
                    );
                  },
                ),
              );
            },
            loading: () => Container(
              height: 120,
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: CircularProgressIndicator(color: colors.acento),
              ),
            ),
            error: (e, st) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: colors.gasto),
                  const SizedBox(width: 8),
                  Text('Error al cargar movimientos', style: TextStyle(color: colors.gasto)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Vista 2: Pestaña "A pagar" (Estrategia Totalera)
class _APagarTabView extends ConsumerStatefulWidget {
  const _APagarTabView();

  @override
  ConsumerState<_APagarTabView> createState() => _APagarTabViewState();
}

class _APagarTabViewState extends ConsumerState<_APagarTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _openEdit(TransactionItem item) {
    AppRouter.toTransactionForm(
      context,
      isEditing: true,
      data: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = context.appColors;
    final tarjetasAsync = ref.watch(tarjetasActivasProvider);
    final ultimosMovimientosAsync = ref.watch(ultimosMovimientosProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta de Tarjetas Activas a Pagar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.superficie,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.textoSecundario.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarjetas de Crédito Activas',
                  style: TextStyle(
                    color: colors.textoSecundario,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                tarjetasAsync.when(
                  data: (cards) {
                    if (cards.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No hay tarjetas de crédito registradas',
                          style: TextStyle(color: colors.textoSecundario, fontSize: 13),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cards.length,
                      separatorBuilder: (ctx, i) => Divider(
                        color: colors.fondo.withValues(alpha: 0.4),
                        height: 24,
                      ),
                      itemBuilder: (ctx, i) {
                        final card = cards[i];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.name,
                                  style: TextStyle(
                                    color: colors.textoPrimario,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pagar: ${card.paymentDate ?? "xx/xx"}',
                                  style: TextStyle(
                                    color: colors.textoSecundario,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'S/ ${card.usedAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colors.textoPrimario,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Consumido',
                                  style: TextStyle(
                                    color: colors.textoSecundario,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(color: colors.acento),
                    ),
                  ),
                  error: (e, st) => Center(
                    child: Icon(Icons.error_outline_rounded, color: colors.gasto),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Título de sección "Últimos movimientos"
          Text(
            'Últimos movimientos',
            style: TextStyle(
              color: colors.textoPrimario,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          // Tarjeta de Últimos Movimientos
          ultimosMovimientosAsync.when(
            data: (txList) {
              if (txList.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.superficie,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'No hay movimientos registrados',
                    style: TextStyle(color: colors.textoSecundario, fontSize: 14),
                  ),
                );
              }

              return Material(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: txList.length,
                  separatorBuilder: (ctx, i) => Divider(
                    color: colors.fondo.withValues(alpha: 0.5),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (ctx, index) {
                    final tx = txList[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (tx.isExpense ? colors.gasto : colors.ingreso).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          tx.isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          color: tx.isExpense ? colors.gasto : colors.ingreso,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        tx.title,
                        style: TextStyle(
                          color: colors.textoPrimario,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        tx.paymentMethod,
                        style: TextStyle(
                          color: colors.textoSecundario,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${tx.isExpense ? '-' : '+'} S/ ${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: tx.isExpense ? colors.textoPrimario : colors.ingreso,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colors.textoSecundario,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () => _openEdit(tx),
                    );
                  },
                ),
              );
            },
            loading: () => Container(
              height: 120,
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: CircularProgressIndicator(color: colors.acento),
              ),
            ),
            error: (e, st) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.superficie,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: colors.gasto),
                  const SizedBox(width: 8),
                  Text('Error al cargar movimientos', style: TextStyle(color: colors.gasto)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
